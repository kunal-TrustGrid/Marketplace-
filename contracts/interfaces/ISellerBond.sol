// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ISellerBond {

    struct Seller {

        bool active;

        uint256 bondedAmount;

        uint256 joinedAt;

        uint256 slashCount;
    }


    function MINIMUM_BOND()

        external

        view

        returns(uint256);



    function marketplaceEscrow()

        external

        view

        returns(address);



    function disputeManager()

        external

        view

        returns(address);



    function depositBond()

        external

        payable;



    function withdrawBond()

        external;



    function slashSeller(

        address seller,

        uint256 amount

    )

        external;



    function isSellerEligible(

        address seller

    )

        external

        view

        returns(bool);



    function getSeller(

        address seller

    )

        external

        view

        returns(

            Seller memory

        );
}