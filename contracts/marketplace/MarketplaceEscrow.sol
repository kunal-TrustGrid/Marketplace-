// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


// ============================================================
// OPENZEPPELIN IMPORTS
// ============================================================

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";


// ============================================================
// PROJECT INTERFACES
// ============================================================

import "../interfaces/IMarketplaceEscrow.sol";
import "../interfaces/ISellerBond.sol";
import "../interfaces/IDisputeManager.sol";
import "../interfaces/ITreasury.sol";


// ============================================================
// MARKETPLACE ESCROW
// ============================================================

contract MarketplaceEscrow is

    IMarketplaceEscrow,

    Ownable,

    Pausable,

    ReentrancyGuard

{

    // ============================================================
    // CONSTANTS
    // ============================================================

    // Percentage calculations
    // 10000 = 100%
    uint256 public constant BASIS_POINTS = 10_000;


    // Seller must dispatch goods within this period
    uint256 public constant SELLER_DISPATCH_DEADLINE = 7 days;


    // Buyer confirms or disputes after delivery
    uint256 public constant BUYER_CONFIRMATION_DEADLINE = 7 days;


    // Dispute allowed after delivery
    uint256 public constant DISPUTE_WINDOW = 7 days;

    uint256 public constant SELLER_SLASH_AMOUNT = 0.005 ether;



    // ============================================================
    // EXTERNAL CONTRACTS
    // ============================================================

    ISellerBond public sellerBond;

    IDisputeManager public disputeManager;

    bool public initialized;



    // ============================================================
    // TREASURY
    // ============================================================

    ITreasury public treasury;



    // ============================================================
    // PLATFORM FEES
    // ============================================================

    // 200 = 2%
    uint256 public platformFee;




    // ============================================================
    // STORAGE
    // ============================================================

    uint256 public nextOrderId;



    // orderId => Order

    mapping(uint256 => Order)

        public orders;



    // orderId => Delivery

    mapping(uint256 => DeliveryInfo)

        public deliveries;



    // buyer => order ids

    mapping(address => uint256[])

        public buyerOrders;



    // seller => order ids

    mapping(address => uint256[])

        public sellerOrders;




    // Total ETH currently locked

    uint256 public totalEscrowBalance;



    // ============================================================
    // EVENTS
    // ============================================================

    event OrderCreated(

        uint256 indexed orderId,

        address indexed buyer,

        address indexed seller,

        bytes32 listingId,

        uint256 amount

    );



    event OrderDispatched(

        uint256 indexed orderId,

        string trackingId,

        string courier,

        uint256 dispatchedAt

    );

    event DeliveryClaimed(

    uint256 indexed orderId,

    string deliveryProofCID,

    uint256 deliveryClaimedAt

);



    event OrderCompleted(

        uint256 indexed orderId,

        uint256 sellerAmount,

        uint256 platformFee

    );



    event OrderRefunded(

        uint256 indexed orderId,

        uint256 amount

    );



    event DisputeRaised(

        uint256 indexed orderId,

        uint256 disputeId

    );



    event PlatformFeeUpdated(

        uint256 oldFee,

        uint256 newFee

    );



    event TreasuryUpdated(

        address oldTreasury,

        address newTreasury

    );



    // ============================================================
    // CUSTOM ERRORS
    // ============================================================

    error ZeroAddress();

    error AlreadyInitialized();

    error ContractNotInitialized();

    error InvalidSeller();

    error InvalidBuyer();

    error InvalidAmount();

    error InvalidPlatformFee();

    error InvalidContractAddress();

    error InvalidOrderState();

    error InvalidProof();

    error InvalidReason();

    error InvalidEvidence();

    error OrderNotFound();

    error Unauthorized();

    error SellerNotEligible();

    error DisputeAlreadyRaised();

    error TimeoutNotReached();

    error TransferFailed();

    error DispatchDeadlinePassed();

    error ConfirmationDeadlinePassed();

    error DeliveryAlreadyClaimed();



    // ============================================================
    // MODIFIERS
    // ============================================================

    modifier orderExists(

        uint256 orderId

    ) {

        if (

            orders[orderId].id == 0

        ) {

            revert OrderNotFound();

        }

        _;

    }



    modifier onlyBuyer(

        uint256 orderId

    ) {

        if (

            orders[orderId].buyer

            !=

            msg.sender

        ) {

            revert Unauthorized();

        }

        _;

    }



    modifier onlySeller(

        uint256 orderId

    ) {

        if (

            orders[orderId].seller

            !=

            msg.sender

        ) {

            revert Unauthorized();

        }

        _;

    }



    modifier onlyDisputeManager() {

        if (

            msg.sender

            !=

            address(disputeManager)

        ) {

            revert Unauthorized();

        }

        _;

    }

    modifier onlyInitialized() {

    if (

        !initialized

    ) {

        revert ContractNotInitialized();

    }

    _;

}



    modifier onlyOrderStatus(

        uint256 orderId,

        OrderStatus status

    ) {

        if (

            orders[orderId].status

            !=

            status

        ) {

            revert InvalidOrderState();

        }

        _;

    }



    // ============================================================
    // CONSTRUCTOR
    // ============================================================

    constructor(

    address _treasury,

    uint256 _platformFee

)

    Ownable(msg.sender)

{

    if (

        _treasury == address(0)

    ) {

        revert ZeroAddress();

    }


    if (

        _platformFee >= BASIS_POINTS

    ) {

        revert InvalidPlatformFee();

    }

    treasury = ITreasury(_treasury);

    platformFee = _platformFee;

    nextOrderId = 1;

}

   function initialize(

    address _sellerBond,

    address _disputeManager

)

    external

    onlyOwner

{

    if (

        initialized

    ) {

        revert AlreadyInitialized();

    }

    if (

        _sellerBond == address(0)

        ||

        _disputeManager == address(0)

    ) {

        revert ZeroAddress();

    }

    if (

        _sellerBond

        ==

        _disputeManager

    ) {

        revert InvalidContractAddress();

    }

    sellerBond = ISellerBond(

        _sellerBond

    );

    disputeManager = IDisputeManager(

        _disputeManager

    );

    initialized = true;

}

       // ============================================================
// CREATE ORDER
// ============================================================

function createOrder(

    bytes32 listingId,

    address seller

)

    external

    payable

    override

    onlyInitialized

    nonReentrant

    whenNotPaused

{

    if (

        seller == address(0)

    ) {

        revert InvalidSeller();

    }


    if (

        seller == msg.sender

    ) {

        revert InvalidBuyer();

    }



    if (

        msg.value == 0

    ) {

        revert InvalidAmount();

    }



    if (

        listingId == bytes32(0)

    ) {

        revert InvalidAmount();

    }



    if (

        !sellerBond.isSellerEligible(

            seller

        )

    ) {

        revert SellerNotEligible();

    }



    uint256 orderId

        =

        nextOrderId;



    orders[orderId]

        =

        Order({

            id : orderId,

            buyer : msg.sender,

            seller : seller,

            amount : msg.value,

            listingId : listingId,

            status : OrderStatus.FUNDS_LOCKED,

            createdAt : block.timestamp,

            dispatchedAt : 0,

            completedAt : 0,

            disputed : false,

            disputeId : 0

        });



    buyerOrders[msg.sender]

        .push(

            orderId

        );



    sellerOrders[seller]

        .push(

            orderId

        );


    totalEscrowBalance += msg.value;
    nextOrderId++;



    emit OrderCreated(

        orderId,

        msg.sender,

        seller,

        listingId,

        msg.value

    );
    

}

     function markDispatched(

    uint256 orderId,

    string calldata trackingId,

    string calldata courier,

    string calldata proofCID

)

    external

    onlyInitialized

    whenNotPaused

    orderExists(orderId)

    onlySeller(orderId)

    onlyOrderStatus(

        orderId,

        OrderStatus.FUNDS_LOCKED

    )

{

    Order storage order

        =

        orders[orderId];

    if (

    bytes(trackingId).length == 0

) {

    revert InvalidProof();

}

if (

    bytes(courier).length == 0

) {

    revert InvalidProof();

}

if (

    bytes(proofCID).length == 0

) {

    revert InvalidProof();

}



    if(

        block.timestamp

        >

        order.createdAt

        +

        SELLER_DISPATCH_DEADLINE

    ){

        revert DispatchDeadlinePassed();

    }



    deliveries[orderId] = DeliveryInfo({

    trackingId: trackingId,

    courier: courier,

    dispatchProofCID: proofCID,

    dispatchedAt: block.timestamp,

    deliveryProofCID: "",

    deliveryClaimedAt: 0

});



order.status

=

OrderStatus.DISPATCHED;

order.dispatchedAt = block.timestamp;



emit OrderDispatched(

    orderId,

    trackingId,

    courier,

    block.timestamp

);

}

  function markDeliveryClaimed(

    uint256 orderId,

    string calldata deliveryProofCID

)

    external

    override

    onlyInitialized

    whenNotPaused

    orderExists(orderId)

    onlySeller(orderId)

    onlyOrderStatus(

        orderId,

        OrderStatus.DISPATCHED

    )

{

    DeliveryInfo storage delivery = deliveries[orderId];

    if (

    bytes(deliveryProofCID).length == 0

) {

    revert InvalidProof();

}

    if (

        delivery.deliveryClaimedAt != 0

    ) {

        revert DeliveryAlreadyClaimed();

    }

    delivery.deliveryProofCID = deliveryProofCID;

    delivery.deliveryClaimedAt = block.timestamp;

    orders[orderId].status = OrderStatus.DELIVERY_CLAIMED;

    emit DeliveryClaimed(

        orderId,

        deliveryProofCID,

        block.timestamp

    );

}

   function confirmDelivery(

    uint256 orderId

)

    external

    override

    onlyInitialized

    whenNotPaused

    orderExists(orderId)

    onlyBuyer(orderId)

    onlyOrderStatus(

        orderId,

        OrderStatus.DELIVERY_CLAIMED

    )

    nonReentrant

{

    Order storage order

        =

        orders[orderId];



    uint256 fee

        =

        (

            order.amount

            *

            platformFee

        )

        /

        BASIS_POINTS;



    uint256 sellerAmount

        =

        order.amount

        -

        fee;



    order.status

        =

        OrderStatus.COMPLETED;



    order.completedAt

        =

        block.timestamp;

    totalEscrowBalance -= order.amount;



    (

        bool treasurySuccess,

    )

    =

    payable(

        address(treasury)

    )

    .call{

        value : fee

    }("");



    if(

        !treasurySuccess

    ){

        revert TransferFailed();

    }



    (

        bool sellerSuccess,

    )

    =

    payable(

        order.seller

    )

    .call{

        value : sellerAmount

    }("");



    if(

        !sellerSuccess

    ){

        revert TransferFailed();

    }



    emit OrderCompleted(

        orderId,

        sellerAmount,

        fee

    );

}

    function buyerRefundAfterTimeout(

    uint256 orderId

)

    external

    override

    onlyInitialized

    whenNotPaused

    orderExists(orderId)

    onlyBuyer(orderId)

    onlyOrderStatus(

        orderId,

        OrderStatus.FUNDS_LOCKED

    )

    nonReentrant

{

    Order storage order = orders[orderId];

    if (

        block.timestamp <

        order.createdAt +

        SELLER_DISPATCH_DEADLINE

    ) {

        revert TimeoutNotReached();

    }

    order.status = OrderStatus.REFUNDED;

    order.completedAt = block.timestamp;

    totalEscrowBalance -= order.amount;

    (bool success, ) = payable(order.buyer).call{

        value: order.amount

    }("");

    if (!success) {

        revert TransferFailed();

    }

    emit OrderRefunded(

        orderId,

        order.amount

    );

}


    function sellerClaimAfterTimeout(

    uint256 orderId

)

    external

    override
    
    onlyInitialized

    whenNotPaused

    orderExists(orderId)

    onlySeller(orderId)

    onlyOrderStatus(

        orderId,

        OrderStatus.DELIVERY_CLAIMED

    )

    nonReentrant

{

    Order storage order = orders[orderId];

    DeliveryInfo storage delivery = deliveries[orderId];

    if (

        block.timestamp <

        delivery.deliveryClaimedAt +

        BUYER_CONFIRMATION_DEADLINE

    ) {

        revert TimeoutNotReached();

    }

    uint256 fee =

        (order.amount * platformFee)

        / BASIS_POINTS;

    uint256 sellerAmount =

        order.amount - fee;

    order.status = OrderStatus.COMPLETED;

    order.completedAt = block.timestamp;

    totalEscrowBalance -= order.amount;

    (bool treasurySuccess, ) = payable(address(treasury)).call{value: fee}("");

    if (!treasurySuccess) {

        revert TransferFailed();

    }

    (bool sellerSuccess, ) = payable(order.seller).call{

        value: sellerAmount

    }("");

    if (!sellerSuccess) {

        revert TransferFailed();

    }

    emit OrderCompleted(

        orderId,

        sellerAmount,

        fee

    );

}


    function raiseDispute(

    uint256 orderId,

    string calldata reason,

    string calldata evidenceCID

)

    external

    override

    onlyInitialized

    whenNotPaused

    orderExists(orderId)

    onlyBuyer(orderId)

    onlyOrderStatus(

        orderId,

        OrderStatus.DELIVERY_CLAIMED

    )

{

    Order storage order = orders[orderId];

    DeliveryInfo storage delivery = deliveries[orderId];

if (

    block.timestamp

    >

    delivery.deliveryClaimedAt

    +

    DISPUTE_WINDOW

) {

    revert ConfirmationDeadlinePassed();

}


    if (

    bytes(reason).length == 0

) {

    revert InvalidReason();

}

if (

    bytes(evidenceCID).length == 0

) {

    revert InvalidEvidence();

}

    if (

        order.disputed

    ) {

        revert DisputeAlreadyRaised();

    }

    uint256 disputeId = disputeManager.createDispute(

        orderId,

        order.buyer,

        order.seller,

        reason,

        evidenceCID

    );

    order.disputed = true;

    order.disputeId = disputeId;

    order.status = OrderStatus.DISPUTED;

    emit DisputeRaised(

        orderId,

        disputeId

    );

}   

    function resolveDispute(

    uint256 orderId,

    bool buyerWins

)

    external

    override

    onlyInitialized

    onlyDisputeManager

    orderExists(orderId)

    onlyOrderStatus(

        orderId,

        OrderStatus.DISPUTED

    )

    nonReentrant

{

    Order storage order = orders[orderId];

    order.completedAt = block.timestamp;

    totalEscrowBalance -= order.amount;

    if (

        buyerWins

    ) {

        order.status = OrderStatus.REFUNDED;

        (bool success, ) = payable(order.buyer).call{

            value: order.amount

        }("");

        if (!success) {

            revert TransferFailed();

        }

        emit OrderRefunded(

            orderId,

            order.amount

        );

        sellerBond.slashSeller(

    order.seller,

    SELLER_SLASH_AMOUNT

);

    }

    else {

        uint256 fee =

            (order.amount * platformFee)

            / BASIS_POINTS;

        uint256 sellerAmount =

            order.amount - fee;

        order.status = OrderStatus.COMPLETED;

        (bool treasurySuccess, ) = payable(address(treasury)).call{
    value: fee
}("");

        if (!treasurySuccess) {

            revert TransferFailed();

        }

        (bool sellerSuccess, ) = payable(order.seller).call{

            value: sellerAmount

        }("");

        if (!sellerSuccess) {

            revert TransferFailed();

        }

        emit OrderCompleted(

            orderId,

            sellerAmount,

            fee

        );

    }

}

    function getOrder(

    uint256 orderId

)

    external

    view

    override

    orderExists(orderId)

    returns (

        Order memory

    )

{

    return orders[orderId];

}



    // ============================================================
    // RECEIVE ETH
    // ============================================================

    receive()

    external

    payable

{

    revert();

}



    fallback()

        external

        payable

    {

        revert();

    }

}