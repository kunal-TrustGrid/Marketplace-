// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IDisputeManager {

    // ============================================================
    // DISPUTE STATUS
    // ============================================================

    enum DisputeStatus {

        NONE,

        ACTIVE,

        JUROR_SELECTION,

        VOTING,

        RESOLVED,

        CANCELLED
    }


    // ============================================================
    // JUROR VOTE
    // ============================================================

    enum Vote {

        NONE,

        BUYER,

        SELLER
    }


    // ============================================================
    // JUROR STRUCT
    // ============================================================

    struct Juror {

        bool active;

        uint256 stakedAmount;

        uint256 totalCases;

        uint256 wonCases;
    }


    // ============================================================
    // DISPUTE STRUCT
    // ============================================================

    struct Dispute {

        uint256 id;

        uint256 orderId;

        address buyer;

        address seller;

        string reason;

        string evidenceCID;

        DisputeStatus status;

        uint256 createdAt;

        uint256 votingEndsAt;

        bool resolved;

        bool buyerWon;
    }


    // ============================================================
    // JUROR FUNCTIONS
    // ============================================================

    function stakeAsJuror()

        external

        payable;



    function withdrawJurorStake()

        external;



    function isJurorEligible(

        address juror

    )

        external

        view

        returns(bool);



    // ============================================================
    // DISPUTE FUNCTIONS
    // ============================================================

    function createDispute(

        uint256 orderId,

        address buyer,

        address seller,

        string calldata reason,

        string calldata evidenceCID

    )

        external

        returns(uint256);

    function ownerSelectJurors(

    uint256 disputeId,

    address[] calldata selectedJurors

)

    external;



    function castVote(

        uint256 disputeId,

        Vote vote

    )

        external;



    function finalizeDispute(

        uint256 disputeId

    )

        external;
        





    // ============================================================
    // VIEW FUNCTIONS
    // ============================================================

    function getDispute(

        uint256 disputeId

    )

        external

        view

        returns(

            Dispute memory

        );



    function getJuror(

        address juror

    )

        external

        view

        returns(

            Juror memory

        );



    function getAssignedJurors(

        uint256 disputeId

    )

        external

        view

        returns(

            address[] memory

        );

}