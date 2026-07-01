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

import "../interfaces/ITreasury.sol";

// ============================================================
// TREASURY
// ============================================================

contract Treasury is
    ITreasury,
    Ownable,
    Pausable,
    ReentrancyGuard
{

    // ============================================================
    // STORAGE
    // ============================================================

    address public override marketplaceEscrow;

    uint256 public override totalReceived;

    uint256 public override totalWithdrawn;

    bool private initialized;

    // ============================================================
    // EVENTS
    // ============================================================

    event TreasuryInitialized(
        address indexed marketplaceEscrow
    );

    event FundsReceived(
        address indexed sender,
        uint256 amount
    );

    event FundsWithdrawn(
        address indexed recipient,
        uint256 amount
    );

    // ============================================================
    // ERRORS
    // ============================================================

    error ZeroAddress();

    error AlreadyInitialized();

    error ContractNotInitialized();

    error Unauthorized();

    error InvalidAmount();

    error TransferFailed();

    // ============================================================
    // MODIFIERS
    // ============================================================

    modifier onlyInitialized() {

        if (!initialized) {

            revert ContractNotInitialized();

        }

        _;
    }

    modifier onlyMarketplaceEscrow() {

        if (
            msg.sender != marketplaceEscrow
        ) {

            revert Unauthorized();

        }

        _;
    }

    // ============================================================
    // CONSTRUCTOR
    // ============================================================

    constructor()
        Ownable(msg.sender)
    {}

    // ============================================================
    // INITIALIZATION
    // ============================================================

    function initialize(

        address _marketplaceEscrow

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
        ) {

            revert ZeroAddress();

        }

        marketplaceEscrow = _marketplaceEscrow;

        initialized = true;

        emit TreasuryInitialized(
            _marketplaceEscrow
        );
    }

    // ============================================================
    // WITHDRAW
    // ============================================================

    function withdraw(

        address payable recipient,

        uint256 amount

    )
        external
        onlyOwner
        onlyInitialized
        nonReentrant
    {

        if (
            recipient == address(0)
        ) {

            revert ZeroAddress();

        }

        if (
            amount == 0 ||
            amount > address(this).balance
        ) {

            revert InvalidAmount();

        }

        totalWithdrawn += amount;

        (bool success,) = recipient.call{
            value: amount
        }("");

        if (!success) {

            revert TransferFailed();

        }

        emit FundsWithdrawn(
            recipient,
            amount
        );
    }

    // ============================================================
    // VIEW
    // ============================================================

    function getBalance()
        external
        view
        returns (uint256)
    {

        return address(this).balance;

    }

    // ============================================================
    // RECEIVE ETH
    // ============================================================

    receive()
        external
        payable
    {

        totalReceived += msg.value;

        emit FundsReceived(
            msg.sender,
            msg.value
        );

    }

    fallback()
        external
        payable
    {

        revert();

    }
}