// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


// ============================================================
// OPENZEPPELIN IMPORTS
// ============================================================

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";


// ============================================================
// PROJECT INTERFACE
// ============================================================

import "../interfaces/ISellerBond.sol";
import "../interfaces/IMarketplaceEscrow.sol";
import "../interfaces/IDisputeManager.sol";


// ============================================================
// SELLER BOND
// ============================================================

contract SellerBond is

    ISellerBond,

    Ownable,

    Pausable,

    ReentrancyGuard

{


    // ============================================================
    // CONSTANTS
    // ============================================================

    uint256 public constant MINIMUM_BOND = 0.01 ether;



    // ============================================================
    // EXTERNAL CONTRACTS
    // ============================================================

    address public marketplaceEscrow;

    address public disputeManager;



    // ============================================================
    // STORAGE
    // ============================================================

    mapping(address => Seller)

        public sellers;



    uint256 public totalBondedAmount;

    bool private initialized;



    // ============================================================
    // EVENTS
    // ============================================================

    event BondDeposited(

        address indexed seller,

        uint256 amount

    );



    event BondWithdrawn(

        address indexed seller,

        uint256 amount

    );



    event SellerSlashed(

        address indexed seller,

        uint256 amount

    );



    event SellerActivated(

        address indexed seller

    );



    event SellerDeactivated(

        address indexed seller

    );



    // ============================================================
    // CUSTOM ERRORS
    // ============================================================

    error ZeroAddress();

    error AlreadyInitialized();

    error ContractNotInitialized();

    error InvalidAmount();

    error InvalidContractAddress();

    error SellerAlreadyActive();

    error SellerNotActive();

    error BondBelowMinimum();

    error Unauthorized();

    error TransferFailed();

    



    // ============================================================
    // MODIFIERS
    // ============================================================

    modifier onlyDisputeManager() {

        if (

            msg.sender

            !=

            disputeManager

        ) {

            revert Unauthorized();

        }

        _;

    }



    modifier onlyActiveSeller() {

        if (

            !sellers[msg.sender].active

        ) {

            revert SellerNotActive();

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



    // ============================================================
    // CONSTRUCTOR
    // ============================================================

    constructor()

    Ownable(msg.sender)

{}

   function initialize(

    address _marketplaceEscrow,

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

        _marketplaceEscrow == address(0)

        ||

        _disputeManager == address(0)

    ) {

        revert ZeroAddress();

    }

    if (

    _marketplaceEscrow

    ==

    _disputeManager

) {

    revert InvalidContractAddress();

}

    marketplaceEscrow = _marketplaceEscrow;

    disputeManager = _disputeManager;

    initialized = true;
}



    // ============================================================
    // SELLER BOND MANAGEMENT
    // ============================================================

    function depositBond()

    external

    payable

    override

    onlyInitialized

    nonReentrant

    whenNotPaused

{

    if (msg.value < MINIMUM_BOND) {

        revert BondBelowMinimum();

    }

    Seller storage seller = sellers[msg.sender];

    if (seller.active) {

        revert SellerAlreadyActive();

    }

    seller.active = true;

    seller.bondedAmount = msg.value;

    seller.joinedAt = block.timestamp;

    seller.slashCount = 0;

    totalBondedAmount += msg.value;

    emit BondDeposited(

        msg.sender,

        msg.value

    );

    emit SellerActivated(

        msg.sender

    );

}



    function withdrawBond()

    external

    override

    onlyInitialized

    nonReentrant

    onlyActiveSeller

{

    Seller storage seller = sellers[msg.sender];

    uint256 amount = seller.bondedAmount;

    seller.active = false;

    seller.bondedAmount = 0;

    totalBondedAmount -= amount;

    (bool success,) = payable(msg.sender).call{

        value: amount

    }("");



    if (!success) {

        revert TransferFailed();

    }

    emit BondWithdrawn(

        msg.sender,

        amount

    );



    emit SellerDeactivated(

        msg.sender

    );

}



    function slashSeller(

    address seller,

    uint256 amount

)

    external

    override

    onlyInitialized

    onlyDisputeManager

{

    Seller storage s = sellers[seller];



    if (!s.active) {

        revert SellerNotActive();

    }



    if (

        amount == 0 ||

        amount > s.bondedAmount

    ) {

        revert InvalidAmount();

    }



    s.bondedAmount -= amount;

    s.slashCount += 1;

    totalBondedAmount -= amount;



    if (

        s.bondedAmount < MINIMUM_BOND

    ) {

        s.active = false;



        emit SellerDeactivated(

            seller

        );

    }



    emit SellerSlashed(

        seller,

        amount

    );

}



    function isSellerEligible(

    address seller

)

    public

    view

    override

    returns(bool)

{

    Seller memory s = sellers[seller];



    return

        s.active

        &&

        s.bondedAmount

        >=

        MINIMUM_BOND;

}



    function getSeller(

        address seller

    )

        external

        view

        override

        returns(

            Seller memory

        )

    {

        return sellers[seller];

    }



    // ============================================================
    // ETH PROTECTION
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