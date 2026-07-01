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

import "../interfaces/IDisputeManager.sol";
import "../interfaces/IMarketplaceEscrow.sol";
import "../interfaces/ISellerBond.sol";


// ============================================================
// DISPUTE MANAGER
// ============================================================

contract DisputeManager is

    IDisputeManager,

    Ownable,

    Pausable,

    ReentrancyGuard

{

    // ============================================================
    // CONSTANTS
    // ============================================================

    uint256 public constant MINIMUM_JUROR_STAKE = 0.01 ether;

    uint256 public constant JURORS_PER_DISPUTE = 3;

    uint256 public constant VOTING_DURATION = 3 days;



    // ============================================================
    // EXTERNAL CONTRACTS
    // ============================================================

    IMarketplaceEscrow public marketplaceEscrow;

    ISellerBond public sellerBond;

    bool public initialized;



    // ============================================================
    // STORAGE
    // ============================================================

    uint256 public nextDisputeId;



    // disputeId => Dispute

    mapping(uint256 => Dispute)

        public disputes;



    // juror => Juror

    mapping(address => Juror)

        public jurors;



    // disputeId => juror => Vote

    mapping(

        uint256 => mapping(address => Vote)

    )

        public jurorVotes;

     mapping(uint256 => uint256)
     public buyerVoteCount;


     mapping(uint256 => uint256)
     public sellerVoteCount;



    // disputeId => jurors

    mapping(

        uint256 => address[]

    )

        public disputeJurors;



    // Total ETH staked by jurors

    uint256 public totalJurorStake;



    // ============================================================
    // EVENTS
    // ============================================================

    event DisputeCreated(

        uint256 indexed disputeId,

        uint256 indexed orderId

    );



    event JurorStaked(

        address indexed juror,

        uint256 amount

    );



    event JurorWithdrawn(

        address indexed juror,

        uint256 amount

    );



    event JurorSelected(

        uint256 indexed disputeId,

        address indexed juror

    );



    event VoteCast(

        uint256 indexed disputeId,

        address indexed juror,

        Vote vote

    );



    event DisputeResolved(

        uint256 indexed disputeId,

        bool buyerWon

    );
    
    event JurorsAssigned(

    uint256 indexed disputeId,

    address[] jurors

);

    event ContractsInitialized(
    address marketplaceEscrow,
    address sellerBond
);


    // ============================================================
    // CUSTOM ERRORS
    // ============================================================

    error ZeroAddress();

    error AlreadyInitialized();

    error ContractNotInitialized();

    error Unauthorized();

    error InvalidAmount();

    error InvalidContractAddress();

    error JurorNotActive();

    error JurorAlreadyActive();

    error InvalidJurorCount();

    error JurorInactive();

    error DisputeNotFound();

    error InvalidDisputeState();

    error AlreadyVoted();

    error NotAssignedJuror();

    error VotingNotEnded();

    error VotingEnded();

    error TransferFailed();

    error DisputeAlreadyResolved();


    // ============================================================
    // MODIFIERS
    // ============================================================

    modifier onlyActiveJuror() {

        if (

            !jurors[msg.sender].active

        ) {

            revert JurorNotActive();

        }

        _;

    }



    modifier disputeExists(

        uint256 disputeId

    ) {

        if (

            disputes[disputeId].id == 0

        ) {

            revert DisputeNotFound();

        }

        _;

    }



    modifier onlyMarketplaceEscrow() {

        if (

            msg.sender

            !=

            address(marketplaceEscrow)

        ) {

            revert Unauthorized();

        }

        _;

    }

     modifier onlyInitialized() {

    if (!initialized) {

        revert ContractNotInitialized();

    }

    _;

}

    modifier onlyAssignedJuror(

    uint256 disputeId

){

    bool found = false;


    address[] memory jurorsList

        =

        disputeJurors[disputeId];


    for(

        uint256 i = 0;

        i < jurorsList.length;

        i++

    ){

        if(

            jurorsList[i]

            ==

            msg.sender

        ){

            found = true;

            break;

        }

    }


    if(!found){

        revert NotAssignedJuror();

    }

    _;

}



    // ============================================================
    // CONSTRUCTOR
    // ============================================================

   constructor()

    Ownable(msg.sender)

{

    nextDisputeId = 1;

}

   function initialize(

    address _marketplaceEscrow,

    address _sellerBond

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

    _sellerBond == address(0)

) {

    revert ZeroAddress();

}

if (

    _marketplaceEscrow

    ==

    _sellerBond

) {

    revert InvalidContractAddress();

}

    marketplaceEscrow = IMarketplaceEscrow(

        _marketplaceEscrow

    );

    sellerBond = ISellerBond(

        _sellerBond

    );

    initialized = true;

    emit ContractsInitialized(
    _marketplaceEscrow,
    _sellerBond
);

}



    // ============================================================
    // VIEW FUNCTIONS
    // ============================================================

    function getDispute(

        uint256 disputeId

    )

        external

        view

        override

        returns(

            Dispute memory

        )

    {

        return disputes[disputeId];

    }



    function getJuror(

        address juror

    )

        external

        view

        override

        returns(

            Juror memory

        )

    {

        return jurors[juror];

    }

    function isJurorEligible(

    address juror

)

    external

    view

    override

    returns (

        bool

    )

{

    return

    jurors[juror].active

    &&

    jurors[juror].stakedAmount

    >=

    MINIMUM_JUROR_STAKE;

}



    function getAssignedJurors(

        uint256 disputeId

    )

        external

        view

        override

        returns(

            address[] memory

        )

    {

        return disputeJurors[disputeId];

    }
     
    // ============================================================
// JUROR MANAGEMENT
// ============================================================

function stakeAsJuror()

    external

    payable

    override

    nonReentrant

    whenNotPaused

{

    if (

        msg.value < MINIMUM_JUROR_STAKE

    ) {

        revert InvalidAmount();

    }


    Juror storage juror = jurors[msg.sender];


    if (

        juror.active

    ) {

        revert JurorAlreadyActive();

    }


    juror.active = true;

    juror.stakedAmount = msg.value;

    juror.totalCases = 0;

    juror.wonCases = 0;


    totalJurorStake += msg.value;


    emit JurorStaked(

        msg.sender,

        msg.value

    );

}

    function withdrawJurorStake()

    external

    override

    onlyInitialized

    nonReentrant

    whenNotPaused

    onlyActiveJuror

{

    Juror storage juror = jurors[msg.sender];


    uint256 amount = juror.stakedAmount;


    juror.active = false;

    juror.stakedAmount = 0;


    totalJurorStake -= amount;


    (bool success, ) = payable(msg.sender).call{

        value: amount

    }("");


    if (!success) {

        revert TransferFailed();

    }


    emit JurorWithdrawn(

        msg.sender,

        amount

    );

}

    function createDispute(

    uint256 orderId,

    address buyer,

    address seller,

    string calldata reason,

    string calldata evidenceCID

)

    external

    override

    onlyInitialized

    onlyMarketplaceEscrow

    returns(uint256)

{

    uint256 disputeId = nextDisputeId;



    disputes[disputeId] = Dispute({

        id: disputeId,

        orderId: orderId,

        buyer: buyer,

        seller: seller,

        reason: reason,

        evidenceCID: evidenceCID,

        status: DisputeStatus.ACTIVE,

        createdAt: block.timestamp,

        votingEndsAt: 0,

        resolved: false,

        buyerWon: false

    });



    nextDisputeId++;



    emit DisputeCreated(

        disputeId,

        orderId

    );



    return disputeId;

}

    function ownerSelectJurors(

    uint256 disputeId,

    address[] calldata selectedJurors

)

    external

    onlyOwner

    onlyInitialized

    whenNotPaused

    disputeExists(disputeId)

{

    if (

        selectedJurors.length

        !=

        JURORS_PER_DISPUTE

    ) {

        revert InvalidJurorCount();

    }



    Dispute storage dispute

        =

        disputes[disputeId];



    if (

        dispute.status

        !=

        DisputeStatus.ACTIVE

    ) {

        revert InvalidDisputeState();

    }



    for (

        uint256 i = 0;

        i < selectedJurors.length;

        i++

    ) {

        address juror

            =

            selectedJurors[i];



        if (

            !jurors[juror].active

        ) {

            revert JurorInactive();

        }

        for (

    uint256 j = 0;

    j < i;

    j++

) {

    if (

        selectedJurors[j]

        ==

        juror

    ) {

        revert InvalidJurorCount();

    }

}



        disputeJurors[disputeId]

            .push(

                juror

            );



        emit JurorSelected(

            disputeId,

            juror

        );

    }



    dispute.status

        =

        DisputeStatus.VOTING;



    dispute.votingEndsAt

        =

        block.timestamp

        +

        VOTING_DURATION;



    emit JurorsAssigned(

        disputeId,

        selectedJurors

    );

}

   function castVote(

    uint256 disputeId,

    Vote vote

)

    external

    override

    onlyInitialized

    whenNotPaused

    disputeExists(disputeId)

    onlyActiveJuror

    onlyAssignedJuror(disputeId)

{

    Dispute storage dispute

        =

        disputes[disputeId];

    if (

    vote == Vote.NONE

) {

    revert InvalidAmount();

}


    if(

        dispute.status

        !=

        DisputeStatus.VOTING

    ){

        revert InvalidDisputeState();

    }


    if(

        block.timestamp

        >

        dispute.votingEndsAt

    ){

        revert VotingEnded();

    }


    if(

        jurorVotes[disputeId][msg.sender]

        !=

        Vote.NONE

    ){

        revert AlreadyVoted();

    }


    jurorVotes[disputeId][msg.sender]

        =

        vote;



    if(

        vote

        ==

        Vote.BUYER

    ){

        buyerVoteCount[disputeId]++;

    }

    else if(

        vote

        ==

        Vote.SELLER

    ){

        sellerVoteCount[disputeId]++;

    }



    emit VoteCast(

        disputeId,

        msg.sender,

        vote

    );

}

    function finalizeDispute(

    uint256 disputeId

)

    external

    override

    onlyInitialized

    disputeExists(disputeId)

{

    Dispute storage dispute

        =

        disputes[disputeId];



    if(

        dispute.resolved

    ){

        revert DisputeAlreadyResolved();

    }



    if(

        dispute.status

        !=

        DisputeStatus.VOTING

    ){

        revert InvalidDisputeState();

    }



    if(

        block.timestamp

        <

        dispute.votingEndsAt

    ){

        revert VotingNotEnded();

    }

    if (

    buyerVoteCount[disputeId]

    +

    sellerVoteCount[disputeId]

    <

    JURORS_PER_DISPUTE

) {

    revert VotingNotEnded();

}



    uint256 buyerVotes

        =

        buyerVoteCount[disputeId];



    uint256 sellerVotes

        =

        sellerVoteCount[disputeId];



    bool buyerWon

        =

        buyerVotes

        >

        sellerVotes;



    dispute.resolved

        =

        true;



    dispute.buyerWon

        =

        buyerWon;



    dispute.status

        =

        DisputeStatus.RESOLVED;



    marketplaceEscrow

        .resolveDispute(

            dispute.orderId,

            buyerWon

        );

        address[] memory assigned = disputeJurors[disputeId];

for (

    uint256 i = 0;

    i < assigned.length;

    i++

) {

    jurors[assigned[i]].totalCases++;

    if (

        jurorVotes[disputeId][assigned[i]]

        ==

        (buyerWon ? Vote.BUYER : Vote.SELLER)

    ) {

        jurors[assigned[i]].wonCases++;

    }

}



    emit DisputeResolved(

        disputeId,

        buyerWon

    );

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