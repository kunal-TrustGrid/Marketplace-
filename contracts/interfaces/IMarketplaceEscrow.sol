// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IMarketplaceEscrow {

    enum OrderStatus {

        NONE,

        FUNDS_LOCKED,

        DISPATCHED,

        DELIVERY_CLAIMED,

        DISPUTED,

        REFUNDED,

        COMPLETED,

        CANCELLED
    }


    struct Order {

        uint256 id;

        address buyer;

        address seller;

        bytes32 listingId;

        uint256 amount;

        OrderStatus status;

        uint256 createdAt;

        uint256 dispatchedAt;

        uint256 completedAt;

        bool disputed;

        uint256 disputeId;
    }

      struct DeliveryInfo {

    // Dispatch
    string trackingId;

    string courier;

    string dispatchProofCID;

    uint256 dispatchedAt;

    // Delivery Claim
    string deliveryProofCID;

    uint256 deliveryClaimedAt;
}


    function createOrder(

        bytes32 listingId,
        address seller

    )

    external

    payable;



    function markDispatched(

    uint256 orderId,

    string calldata trackingId,

    string calldata courier,

    string calldata proofCID

)

external;


    function markDeliveryClaimed(

    uint256 orderId,

    string calldata deliveryProofCID

)

external;



    function confirmDelivery(

        uint256 orderId

    )

    external;



    function raiseDispute(

        uint256 orderId,

        string calldata reason,

        string calldata evidenceCID

    )

    external;



    function resolveDispute(

        uint256 orderId,

        bool buyerWins

    )

    external;



    function sellerClaimAfterTimeout(

        uint256 orderId

    )

    external;



    function buyerRefundAfterTimeout(

        uint256 orderId

    )

    external;



    function getOrder(

        uint256 orderId

    )

    external

    view

    returns (

        Order memory

    );
}