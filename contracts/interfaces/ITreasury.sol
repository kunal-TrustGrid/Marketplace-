// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ITreasury {

    function initialize(
        address marketplaceEscrow
    )
        external;

    function withdraw(
        address payable recipient,
        uint256 amount
    )
        external;

    function getBalance()
        external
        view
        returns(uint256);

    function totalReceived()
        external
        view
        returns(uint256);

    function totalWithdrawn()
        external
        view
        returns(uint256);

    function marketplaceEscrow()
        external
        view
        returns(address);
}