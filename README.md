# Marketplace DAO Protocol

A decentralized escrow-based marketplace protocol built for the **SynQ Social ecosystem**.

The Marketplace DAO Protocol enables secure peer-to-peer trading through Ethereum smart contracts by eliminating the need for centralized intermediaries. Instead of relying on a platform to hold funds, resolve disputes, or determine trust between buyers and sellers, the protocol enforces these rules transparently using immutable smart contracts.

The protocol combines **escrow-based payments**, **seller collateral (bonding)**, **decentralized dispute resolution**, and a **protocol treasury** into a modular architecture that is designed for long-term scalability and future DAO governance.

---

# Project Overview

Traditional online marketplaces require users to trust a centralized organization to:

* Hold buyer payments
* Verify sellers
* Resolve disputes
* Charge marketplace fees
* Manage platform funds

While this model is simple, it introduces several challenges:

* Users must trust the platform with their money.
* Dispute decisions are centralized.
* Platform fees are controlled by a single authority.
* Marketplace rules can change without transparency.

The Marketplace DAO Protocol replaces these centralized responsibilities with smart contracts that execute predefined business rules on-chain.

Instead of trusting a company, users trust the protocol.

The protocol secures buyer payments using an escrow mechanism, requires sellers to maintain collateral through a seller bond system, resolves disputes through juror voting, and collects protocol fees into a dedicated Treasury contract.

---

# Core Features

* Secure escrow-based order settlement
* Seller bond verification and eligibility management
* Delivery confirmation workflow
* Delivery timeout protection
* Buyer dispute mechanism
* Juror-based dispute resolution
* Automatic seller slashing after valid disputes
* Treasury-based protocol fee collection
* Modular smart contract architecture
* Upgrade-friendly initialization pattern
* Hardhat + Remix development workflow

---

# High-Level Architecture

```text
                    Frontend
                        │
                        ▼
                 Backend APIs
                        │
                        ▼
            Marketplace Smart Contracts
                        │
        ┌───────────────┼────────────────┐
        ▼               ▼                ▼
 MarketplaceEscrow   SellerBond   DisputeManager
        │                                │
        └───────────────┬────────────────┘
                        ▼
                    Treasury
```

Each contract is responsible for a single domain of the protocol while communicating with the others through well-defined Solidity interfaces.

---

# Smart Contract Overview

| Contract          | Responsibility                                                                                  |
| ----------------- | ----------------------------------------------------------------------------------------------- |
| MarketplaceEscrow | Manages the complete order lifecycle, escrow funds, delivery workflow, refunds, and settlement. |
| SellerBond        | Stores seller collateral, verifies seller eligibility, and handles slashing after disputes.     |
| DisputeManager    | Creates disputes, manages juror selection, collects votes, and finalizes dispute outcomes.      |
| Treasury          | Receives protocol fees and stores protocol-owned funds.                                         |

---

# Repository Structure

```text
Marketplace-DAO/
│
├── contracts/
│   ├── marketplace/
│   ├── seller/
│   ├── dispute/
│   ├── treasury/
│   └── interfaces/
│
├── scripts/
├── test/
├── docs/
├── hardhat.config.js
├── package.json
└── README.md
```

Detailed explanations for every folder are available in the documentation.

---

# Technology Stack

## Blockchain

* Solidity >=0.8.24
* Hardhat
* OpenZeppelin Contracts

## Development

* Remix IDE
* Hardhat Local Network
* Visual Studio Code

## Storage

* IPFS (Marketplace assets and delivery proofs)
* GunDB (SynQ Social decentralized identity and social layer)

## Backend

* Node.js
* Express.js
* gunJS

---

# Getting Started

Clone the repository:

```bash
git clone <repository-url>
```

Install dependencies:

```bash
npm install
```

Compile contracts:

```bash
npx hardhat compile
```

Start a local blockchain:

```bash
npx hardhat node
```

Connect Remix IDE to the local Hardhat node and deploy the protocol contracts following the Deployment Guide.

---

# Deployment Overview

The contracts must be deployed in the following order:

```text
Treasury
    │
    ▼
SellerBond
    │
    ▼
DisputeManager
    │
    ▼
MarketplaceEscrow
    │
    ▼
Initialize Contract Dependencies
```

The deployment process and initialization sequence are documented in detail in the Deployment Guide.

---

# Testing Overview

The protocol has been tested using a local Hardhat network connected to Remix IDE.

The current test coverage includes:

* Seller bond management
* Juror registration
* Order creation
* Escrow fund locking
* Dispatch workflow
* Delivery claim workflow
* Buyer confirmation
* Treasury settlement
* Balance verification

Additional dispute lifecycle and edge-case testing are documented separately.

---

# Documentation

Detailed technical documentation is available under the **docs/** directory.

| Document                          | Description                                   |
| --------------------------------- | --------------------------------------------- |
| 01_Project_Overview.md            | Product vision and business workflow          |
| 02_System_Architecture.md         | End-to-end protocol architecture              |
| 03_Smart_Contract_Architecture.md | Detailed explanation of every smart contract  |
| 04_Deployment_Guide.md            | Deployment and initialization process         |
| 05_Testing_Guide.md               | Functional and integration testing            |
| 06_Edge_Cases.md                  | Positive and negative test scenarios          |
| 07_Security_Model.md              | Security architecture and protocol guarantees |
| 08_Future_Roadmap.md              | Planned protocol enhancements                 |

---

# Future Roadmap

Planned protocol enhancements include:

* Marketplace Listing Contract
* Wallet ↔ GunJS Identity Binding
* DAO Governance
* VRF-Based Juror Selection
* Juror Reward Distribution
* Treasury Governance
* Automated Hardhat Test Suite
* Protocol Analytics Dashboard
* Transaction dashboard

---

# License

This project is licensed under the MIT License.


# Project Overview

## Introduction

The Marketplace DAO Protocol is a decentralized marketplace infrastructure designed for the **SynQ Social ecosystem**, enabling trustless peer-to-peer commerce through blockchain technology.

Unlike traditional marketplaces where a centralized platform manages payments, verifies sellers, and resolves disputes, the Marketplace DAO Protocol shifts these responsibilities to immutable smart contracts.

The protocol ensures that buyer funds remain secure, sellers are financially accountable through collateral bonding, disputes are resolved transparently, and platform fees are managed by a dedicated Treasury.

Rather than trusting an organization, users trust the protocol itself.

---

# Vision

The long-term vision of the Marketplace DAO Protocol is to become a decentralized commerce layer.

Users should be able to discover products, communicate with sellers, complete purchases, and resolve disputes without relying on centralized intermediaries.

The protocol has been designed to gradually evolve into a fully DAO-governed marketplace where protocol upgrades, treasury management, juror incentives, and governance decisions are managed collectively by the community.

---

# Problems with Traditional Marketplaces

Traditional marketplaces operate under a centralized trust model.

The platform is responsible for:

* Holding buyer payments
* Approving sellers
* Resolving disputes
* Charging marketplace fees
* Managing treasury funds

This introduces several limitations:

* Users must trust the platform with their money.
* Funds can be frozen or delayed.
* Dispute decisions lack transparency.
* Platform rules can change without community approval.
* Marketplace operations depend entirely on a centralized authority.

The Marketplace DAO Protocol addresses these issues by replacing centralized business logic with deterministic smart contracts.

---

# Protocol Objectives

The protocol has been designed with the following objectives:

* Secure buyer funds through escrow.
* Ensure seller accountability using collateral bonds.
* Provide transparent delivery verification.
* Enable decentralized dispute resolution.
* Maintain immutable transaction history.
* Separate protocol revenue into a dedicated Treasury.
* Support future DAO governance.

---

# Protocol Components

The protocol consists of four core smart contracts.

## MarketplaceEscrow

Responsible for the complete order lifecycle.

Responsibilities include:

* Order creation
* Escrow fund locking
* Dispatch tracking
* Delivery confirmation
* Automatic settlement
* Refund processing
* Dispute initiation

---

## SellerBond

Responsible for seller accountability.

Responsibilities include:

* Seller bond deposits
* Seller eligibility verification
* Bond withdrawals
* Seller slashing after valid disputes

---

## DisputeManager

Responsible for decentralized dispute handling.

Responsibilities include:

* Dispute creation
* Juror assignment
* Vote collection
* Result finalization
* Escrow settlement coordination

---

## Treasury

Responsible for protocol-owned funds.

Responsibilities include:

* Platform fee collection
* Treasury balance management
* Future DAO treasury governance

---

# Business Workflow

The marketplace follows a structured lifecycle.

```text
Seller

↓

Deposit Bond

↓

Become Eligible Seller

↓

Create Marketplace Listing (Off-chain)

↓

Buyer Discovers Listing

↓

Create Order

↓

Funds Locked in Escrow

↓

Seller Dispatches Product

↓

Seller Claims Delivery

↓

Buyer Confirms Delivery
```

At this point, one of three outcomes occurs.

---

## Outcome 1 — Successful Transaction

```text
Buyer

↓

Confirm Delivery

↓

MarketplaceEscrow

↓

Platform Fee

↓

Treasury

↓

Remaining Funds

↓

Seller

↓

Order Completed
```

---

## Outcome 2 — Buyer Raises Dispute

```text
Buyer

↓

Raise Dispute

↓

DisputeManager

↓

Owner Assigns Jurors

↓

Jurors Vote

↓

Finalize Dispute

↓

MarketplaceEscrow

↓

Refund Buyer

OR

Pay Seller

↓

Close Order
```

---

## Outcome 3 — Buyer Becomes Inactive

```text
Seller

↓

Claim Delivery

↓

Buyer Gives No Response

↓

7-Day Timeout

↓

Seller Claims Escrow

↓

Treasury Receives Fee

↓

Seller Paid
```

---

# Order Lifecycle

Every marketplace order progresses through predefined states.

```text
FUNDS_LOCKED

↓

DISPATCHED

↓

DELIVERY_CLAIMED

↓

├───────────────┐
│               │
▼               ▼
COMPLETED   DISPUTED
                │
                ▼
      REFUNDED / COMPLETED
```

This deterministic state machine ensures that every order follows a predictable lifecycle and prevents invalid state transitions.

---

# Why Seller Bonds?

Seller bonds introduce financial accountability.

Every seller must lock collateral before participating in the marketplace.

If a seller repeatedly violates marketplace rules or loses disputes, part of the bonded collateral can be slashed.

Benefits include:

* Discourages fraudulent sellers.
* Encourages responsible behavior.
* Reduces marketplace spam.
* Creates economic accountability.

---

# Why Escrow?

Escrow protects both parties.

Buyer funds remain locked inside the MarketplaceEscrow contract until one of the following occurs:

* Buyer confirms delivery.
* Seller claims after timeout.
* Dispute resolution determines the outcome.

Neither the buyer nor the seller can access escrow funds prematurely.

---

# Why Juror-Based Dispute Resolution?

Instead of allowing a centralized organization to resolve disputes, the protocol delegates dispute decisions to independent jurors.

Jurors evaluate submitted evidence and vote for either the buyer or seller.

The majority decision determines how escrow funds are distributed.

This process improves transparency and reduces centralized control.

---

# Treasury

The Treasury contract acts as the financial reserve of the protocol.

It collects:

* Marketplace platform fees
* Future protocol revenue
* Governance-controlled funds

Initially, the Treasury operates under owner control.

In future versions, Treasury management will transition to DAO governance.

---

# Current Scope

The current implementation includes:

* Escrow management
* Seller bond system
* Treasury
* Juror-based dispute framework
* Cross-contract communication
* Contract initialization
* Functional testing on Hardhat + Remix

Marketplace listing management, DAO governance, and juror reward mechanisms are planned for future releases.

---

Architectural Philosophy

The protocol follows a simple principle:

Store only what must be immutable on-chain. Everything else remains decentralized but off-chain.

This approach provides:

Lower gas costs
Better scalability
Faster user experience
Immutable financial operations
Decentralized content storage
Layer 1 — Frontend

The frontend is the primary interface through which buyers and sellers interact with the marketplace.

Responsibilities include:

User registration
Wallet connection
Marketplace browsing
Product creation
Product purchase
Order tracking
Dispute management
DAO governance (future)

The frontend never communicates directly with blockchain storage.

Instead, it communicates through backend APIs and wallet transactions.

Layer 2 — Backend APIs

The backend acts as the orchestration layer between the frontend, decentralized storage, and blockchain.

Responsibilities include:

Authentication
Request validation
Marketplace APIs
IPFS uploads
GunDB synchronization
Smart contract transaction preparation
Event indexing
Analytics
Notification servicesq

The backend never controls user funds.

Financial ownership always remains with blockchain wallets.

Layer 3 — GunDB

GunDB stores decentralized marketplace metadata that does not require blockchain immutability.

Examples include:

Marketplace listings
Product descriptions
Seller profile information
Product categories
Product tags
User reputation data
Marketplace search indexes

GunDB provides low-latency decentralized data synchronization while avoiding unnecessary blockchain transactions.

Layer 4 — IPFS

IPFS stores large immutable files.

Examples include:

Product images
Product videos
Product manuals
Dispatch proof documents
Delivery proof screenshots
Marketplace media

Only the corresponding Content Identifier (CID) is referenced by the application.

Large binary files are never stored on-chain.

Layer 5 — Smart Contracts

The blockchain layer stores only business-critical information.

The protocol consists of four independent smart contracts.

MarketplaceEscrow

The MarketplaceEscrow contract is responsible for the complete financial lifecycle of an order.

Responsibilities include:

Order creation
Escrow fund locking
Dispatch tracking
Delivery confirmation
Timeout settlement
Refund processing
Cross-contract communication
Treasury fee calculation

MarketplaceEscrow acts as the central coordinator of the protocol.

SellerBond

SellerBond maintains seller accountability.

Responsibilities include:

Bond deposits
Seller eligibility verification
Bond withdrawals
Seller slashing

Before a seller can participate in the marketplace, they must lock collateral into this contract.

DisputeManager

DisputeManager manages decentralized dispute resolution.

Responsibilities include:

Dispute creation
Juror management
Juror voting
Vote counting
Final dispute resolution

It never directly transfers escrow funds.

Instead, it communicates the dispute outcome back to MarketplaceEscrow.

Treasury

Treasury manages protocol-owned funds.

Responsibilities include:

Platform fee collection
Treasury accounting
Governance-controlled withdrawals (future)

Treasury remains completely isolated from marketplace business logic.

Cross-Contract Communication

The protocol follows a modular architecture where each contract owns its own business domain.

Contracts communicate through Solidity interfaces.

MarketplaceEscrow
       │
       ├────────────► SellerBond
       │
       ├────────────► DisputeManager
       │
       └────────────► Treasury

Benefits of this architecture include:

Loose coupling
Easier upgrades
Cleaner code separation
Improved auditability
Better testability
Data Classification

The protocol classifies data into three categories.

On-Chain Data

Financially critical information:

Orders
Escrow balances
Seller bonds
Juror votes
Treasury balances
Order status
Dispute status
Off-Chain Data

Marketplace metadata:

Product descriptions
Categories
User profiles
Marketplace search indexes
Social interactions
Analytics
Decentralized File Storage

Large immutable assets:

Images
Videos
Delivery screenshots
Product documentation
Dispatch proofs
Order Processing Flow
Buyer

↓

Select Marketplace Listing

↓

Backend Retrieves Listing Metadata

↓

Buyer Signs Transaction

↓

MarketplaceEscrow.createOrder()

↓

Funds Locked

↓

Seller Dispatches Product

↓

Seller Claims Delivery

↓

Buyer Confirms Delivery

↓

MarketplaceEscrow

↓

Treasury Receives Platform Fee

↓

Seller Receives Remaining Funds
Dispute Processing Flow
Buyer

↓

Raise Dispute

↓

MarketplaceEscrow

↓

DisputeManager.createDispute()

↓

Owner Assigns Jurors

↓

Jurors Vote

↓

Finalize Dispute

↓

MarketplaceEscrow.resolveDispute()

↓

Refund Buyer

OR

Pay Seller

↓

Slash Seller Bond (if applicable)
Why This Architecture?

The protocol intentionally separates responsibilities across multiple layers.

This provides several advantages:

Smart contracts remain focused on financial logic.
Large files remain outside the blockchain.
Marketplace metadata can evolve without contract upgrades.
Backend services improve user experience without compromising decentralization.
Every component can scale independently.

This modular architecture also simplifies auditing because each contract has a clearly defined responsibility.

Future Architecture

The current implementation establishes the foundation for future protocol expansion.

Planned additions include:

Marketplace Listing Smart Contract
DAO Governance Contract
Juror Reward Contract
Reputation System
Marketplace Analytics
Governance Treasury
Cross-chain Marketplace Support

The existing architecture has been designed to accommodate these future modules without requiring major changes to the current protocol.


# Smart Contract Architecture

## Introduction

The Marketplace DAO Protocol follows a modular smart contract architecture where every contract is responsible for a single business domain.

Instead of implementing the complete marketplace inside one large contract, the protocol separates financial settlement, seller accountability, dispute resolution, and treasury management into independent contracts.

This approach improves:

* Code maintainability
* Security
* Upgradeability
* Testability
* Auditability

Each contract owns its own storage and communicates with the others through Solidity interfaces.

---

# Contract Architecture

```text
                         MarketplaceEscrow
                         (Core Coordinator)
                                 │
          ┌──────────────────────┼──────────────────────┐
          │                      │                      │
          ▼                      ▼                      ▼
     SellerBond           DisputeManager           Treasury
          │                      │
          └───────────────Interfaces───────────────┘
```

MarketplaceEscrow acts as the central coordinator.

The remaining contracts perform specialized responsibilities.

---

# Smart Contract Design Principles

The protocol has been designed around the following principles.

## Single Responsibility Principle

Every contract owns one business domain.

| Contract          | Responsibility    |
| ----------------- | ----------------- |
| MarketplaceEscrow | Orders and escrow |
| SellerBond        | Seller collateral |
| DisputeManager    | Dispute handling  |
| Treasury          | Protocol funds    |

---

## Loose Coupling

Contracts never access each other's storage directly.

Instead they communicate through interfaces.

Example:

```text
MarketplaceEscrow

↓

ISellerBond

↓

SellerBond
```

This makes contracts easier to replace or upgrade in future protocol versions.

---

## Modular Business Logic

Instead of one large marketplace contract, the protocol separates:

* Payments
* Seller management
* Juror management
* Treasury accounting

Each module can evolve independently.

---

# Contract Overview

The protocol currently consists of four primary contracts.

---

# 1. MarketplaceEscrow

## Purpose

MarketplaceEscrow is the core contract of the protocol.

It coordinates the complete order lifecycle from payment until settlement.

Every purchase made through the marketplace passes through this contract.

---

## Responsibilities

* Create orders
* Lock buyer funds
* Store order state
* Track dispatch
* Track delivery claims
* Handle buyer confirmation
* Handle seller timeout claims
* Raise disputes
* Resolve disputes
* Transfer platform fees
* Release seller payments
* Issue refunds

---

## Stored Data

MarketplaceEscrow maintains:

* Orders
* Delivery information
* Escrow balances
* Platform fee
* Treasury reference
* SellerBond reference
* DisputeManager reference

---

## Order State Machine

```text
FUNDS_LOCKED

↓

DISPATCHED

↓

DELIVERY_CLAIMED

↓

├───────────────┐
│               │
▼               ▼
COMPLETED   DISPUTED
                │
                ▼
      REFUNDED / COMPLETED
```

The contract enforces valid state transitions and prevents invalid operations.

---

## Cross-Contract Communication

MarketplaceEscrow communicates with:

SellerBond

* Verify seller eligibility
* Slash seller after dispute

DisputeManager

* Create disputes
* Receive dispute outcome

Treasury

* Transfer platform fees

MarketplaceEscrow never stores seller collateral or dispute information itself.

---

# 2. SellerBond

## Purpose

SellerBond ensures that every marketplace seller maintains financial accountability.

Before participating in the marketplace, sellers must deposit collateral.

This collateral acts as economic security against fraudulent behavior.

---

## Responsibilities

* Accept seller bonds
* Verify seller eligibility
* Allow bond withdrawal
* Slash seller collateral
* Maintain seller records

---

## Stored Data

SellerBond maintains:

* Seller information
* Bond amount
* Seller activation status
* Join timestamp
* Slash history

---

## Seller Lifecycle

```text
Seller

↓

Deposit Bond

↓

Eligible

↓

Marketplace Trading

↓

Normal Exit
OR
Bond Slashed
```

---

## Why Separate SellerBond?

Keeping seller collateral separate from MarketplaceEscrow provides:

* Better separation of concerns
* Cleaner audits
* Easier future upgrades
* Independent seller management

---

# 3. DisputeManager

## Purpose

DisputeManager is responsible for decentralized dispute resolution.

It does not own escrow funds.

Instead, it determines the dispute outcome and instructs MarketplaceEscrow how to settle the order.

---

## Responsibilities

* Register jurors
* Accept juror stake
* Create disputes
* Assign jurors
* Record votes
* Finalize disputes

---

## Stored Data

DisputeManager maintains:

* Disputes
* Jurors
* Assigned jurors
* Votes
* Vote counts
* Dispute status

---

## Dispute Lifecycle

```text
Buyer

↓

Raise Dispute

↓

ACTIVE

↓

Owner Selects Jurors

↓

VOTING

↓

Finalize

↓

MarketplaceEscrow
```

---

## Why Separate DisputeManager?

Advantages include:

* Independent dispute logic
* Easier governance upgrades
* Cleaner contract responsibilities
* Better auditability

---

# 4. Treasury

## Purpose

Treasury stores protocol-owned funds.

MarketplaceEscrow transfers protocol fees to Treasury after successful settlement.

Treasury does not participate in order processing.

---

## Responsibilities

* Receive protocol fees
* Maintain treasury balance
* Future governance-controlled withdrawals

---

## Stored Data

Treasury maintains:

* Treasury balance
* Owner permissions
* Future governance parameters

---

# Interface Architecture

Every contract communicates through Solidity interfaces.

Interfaces define:

* Function signatures
* Structs
* Enums
* Events

Interfaces contain no executable logic.

They exist only during compilation.

---

## Why Interfaces?

Interfaces provide:

* Type safety
* Cleaner external calls
* Reduced contract coupling
* Easier testing

Without interfaces, contracts would need to perform low-level `address.call()` operations.

---

# Contract Initialization

The protocol uses an initialization pattern instead of constructor-based dependency injection.

Deployment occurs first.

Contracts are connected afterwards.

```text
Deploy Treasury

↓

Deploy SellerBond

↓

Deploy DisputeManager

↓

Deploy MarketplaceEscrow

↓

Initialize MarketplaceEscrow

↓

Initialize SellerBond

↓

Initialize DisputeManager
```

This solves circular dependency problems while keeping deployment simple.

---

# Cross-Contract Communication

```text
MarketplaceEscrow

│

├────────► SellerBond
│          │
│          └── Verify seller
│
├────────► DisputeManager
│          │
│          └── Create dispute
│
└────────► Treasury
           │
           └── Transfer platform fee
```

Each contract exposes only the functions required by the others.

No contract directly modifies another contract's storage.

---

# Security Principles

The contracts have been designed with several security layers.

## Access Control

Sensitive functions are protected through ownership and role-based modifiers.

Examples include:

* onlyOwner
* onlyBuyer
* onlySeller
* onlyDisputeManager
* onlyMarketplaceEscrow

---

## Reentrancy Protection

Every function that transfers Ether is protected using OpenZeppelin's ReentrancyGuard.

---

## Emergency Pause

User-facing operations can be paused during emergencies using OpenZeppelin's Pausable module.

Critical administrative operations remain available where appropriate.

---

## Initialization Protection

Each contract can only be initialized once.

This prevents dependency reconfiguration after deployment.

---

## Deterministic State Machine

Every order follows a predefined lifecycle.

Invalid state transitions are rejected.

This prevents inconsistent marketplace behavior.

---

# Current Protocol Scope

The current implementation includes:

* Escrow settlement
* Seller bonds
* Treasury management
* Juror registration
* Dispute framework
* Cross-contract communication
* Initialization system
* Hardhat + Remix integration

---

# Deployment Guide

## Introduction

This document explains the complete deployment process of the Marketplace DAO Protocol.

It covers everything from setting up the local development environment to deploying and initializing every smart contract.

The Marketplace DAO Protocol uses a modular architecture where multiple smart contracts communicate with each other through Solidity interfaces. Because these contracts depend on one another, deployment must follow a specific order.

By the end of this guide, you will have:

* A local blockchain running
* Remix IDE connected to your local environment
* All smart contracts deployed
* Contract dependencies initialized
* Cross-contract communication verified
* The protocol ready for functional testing

---

# Development Environment

The protocol is developed using the following tools.

| Tool               | Purpose                            |
| ------------------ | ---------------------------------- |
| Visual Studio Code | Smart contract development         |
| Hardhat            | Compilation and local blockchain   |
| Remix IDE          | Deployment and interactive testing |
| Node.js            | Development runtime                |
| OpenZeppelin       | Security libraries                 |

---

# Project Setup

Clone the repository.

```bash
git clone <repository-url>
```

Navigate into the project.

```bash
cd Marketplace-DAO
```

Install project dependencies.

```bash
npm install
```

Compile all smart contracts.

```bash
npx hardhat compile
```

If compilation succeeds, Hardhat generates the required contract artifacts.

---

# Start the Local Blockchain

Launch the Hardhat development network.

```bash
npx hardhat node
```

Hardhat starts a local Ethereum blockchain.

The terminal displays:

* Local RPC URL
* Twenty pre-funded accounts
* Twenty private keys

Keep this terminal running throughout development.

---

# Connect Remix IDE

Open Remix IDE.

Select:

```
Workspaces

↓

Connect to Localhost
```

Connect the repository using RemixD.

Once connected:

* Your local contract files become visible inside Remix.
* Changes saved in Visual Studio Code immediately appear inside Remix.

---

# Connect Remix to Hardhat

Inside Remix:

```
Deploy & Run Transactions

↓

Environment

↓

Dev - Hardhat Provider
```

Connect Remix to the local Hardhat node.

Once connected:

* Remix uses the same accounts provided by Hardhat.
* Every deployment occurs on the local blockchain.

---

# Recommended Test Accounts

The following account mapping is recommended throughout development.

| Account    | Purpose        |
| ---------- | -------------- |
| Account #0 | Protocol Owner |
| Account #1 | Treasury Owner |
| Account #2 | Seller         |
| Account #3 | Buyer          |
| Account #4 | Juror 1        |
| Account #5 | Juror 2        |
| Account #6 | Juror 3        |

Using consistent accounts makes testing easier to understand and reproduce.

---

# Deployment Order

The Marketplace DAO Protocol must be deployed in the following order.

```text
Treasury

↓

SellerBond

↓

DisputeManager

↓

MarketplaceEscrow
```

This order avoids circular dependency issues during deployment.

---

# Step 1 — Deploy Treasury

Deploy:

```
Treasury.sol
```

Constructor parameters:

None

After deployment:

* Copy the deployed contract address.
* This address will be required during MarketplaceEscrow deployment.

---

# Step 2 — Deploy SellerBond

Deploy:

```
SellerBond.sol
```

Constructor parameters:

None

After deployment:

* Copy the deployed contract address.

---

# Step 3 — Deploy DisputeManager

Deploy:

```
DisputeManager.sol
```

Constructor parameters:

None

After deployment:

* Copy the deployed contract address.

---

# Step 4 — Deploy MarketplaceEscrow

Deploy:

```
MarketplaceEscrow.sol
```

Constructor parameters:

| Parameter        | Value                     |
| ---------------- | ------------------------- |
| Treasury Address | Treasury contract address |
| Platform Fee     | 250                       |

A platform fee of **250** represents **2.5%**, using a basis points system.

After deployment:

* Copy the deployed MarketplaceEscrow address.

---

# Contract Initialization

After deployment, the contracts must be linked together.

Deployment only creates the contracts.

Initialization establishes communication between them.

---

## Initialize SellerBond

Call:

```
initialize(
    marketplaceEscrow,
    disputeManager
)
```

Parameters:

* MarketplaceEscrow Address
* DisputeManager Address

---

## Initialize DisputeManager

Call:

```
initialize(
    marketplaceEscrow,
    sellerBond
)
```

Parameters:

* MarketplaceEscrow Address
* SellerBond Address

---

## Initialize MarketplaceEscrow

Call:

```
initialize(
    sellerBond,
    disputeManager
)
```

Parameters:

* SellerBond Address
* DisputeManager Address

---

# Why Initialization?

Instead of injecting every dependency through constructors, the protocol uses a one-time initialization process.

Benefits include:

* Solves circular dependency problems.
* Simplifies deployment.
* Allows contracts to be deployed independently.
* Prevents contract addresses from changing after initialization.

Each contract can only be initialized once.

---

# Verify Cross-Contract Wiring

After initialization, verify every dependency.

---

## MarketplaceEscrow

Verify:

```
sellerBond()
```

Expected:

SellerBond contract address

---

Verify:

```
disputeManager()
```

Expected:

DisputeManager contract address

---

Verify:

```
treasury()
```

Expected:

Treasury contract address

---

## SellerBond

Verify:

```
marketplaceEscrow()
```

Expected:

MarketplaceEscrow contract address

---

Verify:

```
disputeManager()
```

Expected:

DisputeManager contract address

---

## DisputeManager

Verify:

```
marketplaceEscrow()
```

Expected:

MarketplaceEscrow contract address

---

Verify:

```
sellerBond()
```

Expected:

SellerBond contract address

---

# Deployment Verification Checklist

Before beginning functional testing, verify the following.

✅ All contracts compiled successfully.

✅ Local Hardhat node is running.

✅ Remix connected to Hardhat.

✅ Treasury deployed.

✅ SellerBond deployed.

✅ DisputeManager deployed.

✅ MarketplaceEscrow deployed.

✅ SellerBond initialized.

✅ DisputeManager initialized.

✅ MarketplaceEscrow initialized.

✅ Cross-contract addresses verified.

---

# Common Deployment Issues

## Incorrect Deployment Order

Deploying MarketplaceEscrow before Treasury results in an invalid constructor parameter.

Always follow the documented deployment order.

---

## Forgetting Initialization

Deployment alone is not sufficient.

Every contract must be initialized before interacting with the protocol.

---

## Incorrect Contract Address

Passing an incorrect contract address during initialization prevents proper cross-contract communication.

Always verify addresses immediately after initialization.

---

## Multiple Initialization Attempts

Each contract can only be initialized once.

Subsequent initialization attempts will revert.

---

## Wrong Network

Always confirm that Remix is connected to:

```
Dev - Hardhat Provider
```

before deploying.

---

# Ready for Testing

Once deployment and initialization are complete, the protocol is ready for functional testing.

At this stage, developers should proceed with:

* Seller onboarding
* Juror registration
* Order creation
* Delivery workflow
* Escrow settlement
* Dispute lifecycle
* Edge-case validation

These procedures are covered in the next document.

---

# Testing Guide

## Introduction

This document describes the complete functional testing process for the Marketplace DAO Protocol.

The objective of testing is to verify that:

* Every smart contract behaves as expected.
* Cross-contract communication works correctly.
* Escrow funds remain secure.
* Seller eligibility is enforced.
* Treasury receives protocol fees correctly.
* Order state transitions are valid.
* Business rules cannot be bypassed.
* Invalid operations revert as expected.

All testing described in this guide is performed on a local Hardhat blockchain using Remix IDE connected through the Hardhat Provider.

---

# Test Environment

## Development Stack

| Component             | Tool                  |
| --------------------- | --------------------- |
| Smart Contracts       | Solidity              |
| Development Framework | Hardhat               |
| Blockchain            | Hardhat Local Network |
| Interactive Testing   | Remix IDE             |
| IDE                   | Visual Studio Code    |

---

# Test Accounts

Use the same accounts throughout testing.

| Hardhat Account | Role                      |
| --------------- | ------------------------- |
| Account #0      | Protocol Owner            |
| Account #1      | Treasury Owner (optional) |
| Account #2      | Seller                    |
| Account #3      | Buyer                     |
| Account #4      | Juror 1                   |
| Account #5      | Juror 2                   |
| Account #6      | Juror 3                   |

Keeping account roles fixed makes the testing process repeatable.

---

# Testing Sequence

Always execute tests in the following order.

```text
Deploy Contracts

↓

Initialize Contracts

↓

Seller Bond

↓

Juror Registration

↓

Create Order

↓

Dispatch Product

↓

Claim Delivery

↓

Buyer Confirmation

↓

Settlement Verification

↓

Dispute Workflow

↓

Timeout Workflow

↓

Negative Test Cases
```

Executing tests in this order ensures every prerequisite has already been satisfied before the next stage begins.

---

# Phase 1 — Deployment Verification

Verify that:

* All contracts deploy successfully.
* No constructor reverts.
* Contract addresses are generated.
* Initialization completes successfully.

Verify stored addresses using getter functions.

MarketplaceEscrow:

* sellerBond()
* disputeManager()
* treasury()

SellerBond:

* marketplaceEscrow()
* disputeManager()

DisputeManager:

* marketplaceEscrow()
* sellerBond()

Expected Result:

All getter functions should return the correct deployed contract addresses.

---

# Phase 2 — Seller Bond Testing

## Test Case 1 — Deposit Bond

Role:

Seller (Account #2)

Function:

depositBond()

ETH Sent:

0.01 ETH

Expected Result:

* Seller becomes active.
* Bond amount is recorded.
* Total bonded amount increases.

Verify:

getSeller(Account2)

Expected values:

* active = true
* bondedAmount = 0.01 ETH
* slashCount = 0

---

## Test Case 2 — Seller Eligibility

Function:

isSellerEligible(Account2)

Expected Result:

true

---

## Negative Tests

Attempt:

* Deposit less than minimum bond.
* Deposit bond twice.

Expected Result:

Transaction reverts.

---

# Phase 3 — Juror Registration

Each juror performs:

stakeAsJuror()

Accounts:

* Account #4
* Account #5
* Account #6

ETH Sent:

0.01 ETH

Verify:

getJuror()

Expected:

* active = true
* correct stake amount
* totalCases = 0
* wonCases = 0

---

## Negative Tests

Attempt:

* Stake below minimum amount.
* Stake twice using the same account.

Expected:

Transaction reverts.

---

# Phase 4 — Order Creation

Buyer:

Account #3

Function:

createOrder()

Example Listing ID:

```text
0x1111111111111111111111111111111111111111111111111111111111111111
```

Seller:

Account #2

ETH Sent:

1 ETH

Expected:

* Order created.
* Escrow receives 1 ETH.
* Order status becomes FUNDS_LOCKED.

Verify:

getOrder(1)

Expected:

* Buyer address
* Seller address
* Amount = 1 ETH
* Status = FUNDS_LOCKED
* createdAt populated

---

## Balance Verification

Verify:

MarketplaceEscrow balance increases by 1 ETH.

---

# Phase 5 — Dispatch Workflow

Seller:

Account #2

Function:

markDispatched()

Parameters:

* Tracking ID
* Courier
* Dispatch Proof CID

Expected:

* Delivery information stored.
* Order status becomes DISPATCHED.
* Dispatch timestamp recorded.

Verify delivery information.

Expected:

* Tracking ID
* Courier
* Dispatch CID
* Dispatch timestamp

---

## Negative Tests

Attempt:

* Dispatch twice.
* Dispatch after timeout.
* Dispatch by buyer.

Expected:

Transaction reverts.

---

# Phase 6 — Delivery Claim

Seller:

Account #2

Function:

markDeliveryClaimed()

Parameter:

Delivery Proof CID

Expected:

* Delivery proof stored.
* deliveryClaimedAt populated.
* Status becomes DELIVERY_CLAIMED.

Verify:

Delivery information.

---

## Negative Tests

Attempt:

* Claim delivery twice.
* Claim before dispatch.

Expected:

Transaction reverts.

---

# Phase 7 — Buyer Confirmation

Buyer:

Account #3

Function:

confirmDelivery()

Expected:

* Seller receives payment.
* Treasury receives platform fee.
* Escrow balance decreases.
* Order status becomes COMPLETED.
* completedAt populated.

---

# Settlement Verification

Verify:

Treasury balance increased.

Verify:

Seller balance increased.

Verify:

MarketplaceEscrow balance reduced.

Verify:

Order status equals COMPLETED.

---

# Phase 8 — Dispute Workflow

Create a new order.

Follow the dispatch workflow.

Instead of confirming delivery:

Buyer calls:

raiseDispute()

Expected:

* Order status becomes DISPUTED.
* Dispute created.
* Dispute ID assigned.

Verify:

* getOrder()
* getDispute()

---

# Juror Assignment

Owner calls:

ownerSelectJurors()

Expected:

Three jurors assigned.

Verify:

getAssignedJurors()

---

# Voting

Each juror calls:

castVote()

Verify:

* Vote recorded.
* Vote counts updated.

---

# Finalization

Call:

finalizeDispute()

Expected:

* Majority vote determines winner.
* MarketplaceEscrow resolves the dispute.
* Buyer refunded or seller paid.
* Seller bond slashed if applicable.

---

# Phase 9 — Timeout Workflow

Create a new order.

Dispatch.

Claim delivery.

Do not call:

confirmDelivery()

Advance blockchain time (or wait during testing).

Seller calls:

sellerClaimAfterTimeout()

Expected:

* Seller receives funds.
* Treasury receives platform fee.
* Order status becomes COMPLETED.

---

# Buyer Refund Timeout

If your implementation supports buyer refund timeout:

Create an order.

Do not dispatch within the allowed dispatch window.

Buyer calls:

buyerRefundAfterTimeout()

Expected:

* Buyer refunded.
* Order status becomes REFUNDED.

---

# Getter Function Verification

Verify every public getter after major state transitions.

MarketplaceEscrow:

* getOrder()

SellerBond:

* getSeller()
* isSellerEligible()

DisputeManager:

* getDispute()
* getAssignedJurors()
* getJuror()

Treasury:

* Treasury balance
* Fee accounting functions (if implemented)

---

# Event Verification

Verify that every successful operation emits the correct event.

Examples include:

* OrderCreated
* OrderDispatched
* DeliveryClaimed
* OrderCompleted
* OrderRefunded
* DisputeRaised
* JurorSelected
* VoteCast
* DisputeResolved
* BondDeposited
* BondWithdrawn
* SellerSlashed

---

# Test Completion Checklist

Successful testing confirms:

✅ Contract deployment

✅ Initialization

✅ Seller onboarding

✅ Juror onboarding

✅ Order creation

✅ Dispatch workflow

✅ Delivery claim workflow

✅ Buyer confirmation

✅ Escrow settlement

✅ Treasury fee collection

✅ Getter validation

✅ Event emission

✅ Dispute lifecycle

✅ Timeout handling

---

# Edge Cases & Negative Testing Guide

## Introduction

A secure smart contract protocol must not only execute valid operations successfully but also reject invalid operations predictably.

This document describes the negative testing scenarios, invalid state transitions, unauthorized access attempts, timeout conditions, and protocol abuse cases that must be validated before deployment.

The objective is to ensure that the Marketplace DAO Protocol remains secure even when users intentionally or accidentally perform invalid operations.

---

# Testing Philosophy

Every public function should satisfy the following principles:

* Accept valid inputs.
* Reject invalid inputs.
* Reject unauthorized callers.
* Reject invalid state transitions.
* Preserve protocol funds.
* Leave storage unchanged after failed transactions.

Every reverted transaction is considered a successful security test.

---

# MarketplaceEscrow Edge Cases

---

## Order Creation

### Create Order with Zero ETH

Function:

createOrder()

Input:

msg.value = 0

Expected Result:

Transaction reverts.

Reason:

Escrow cannot lock zero-value orders.

---

### Create Order with Invalid Seller

Input:

Seller address not bonded.

Expected Result:

Transaction reverts.

Reason:

Only eligible sellers may receive orders.

---

### Create Order with Zero Seller Address

Input:

seller = address(0)

Expected Result:

Transaction reverts.

---

### Duplicate Listing Orders

Create multiple orders using the same listing ID.

Expected Result:

Protocol should allow multiple independent orders because listing IDs identify products rather than unique purchases.

---

# Dispatch Workflow

---

### Dispatch by Buyer

Buyer attempts:

markDispatched()

Expected Result:

Transaction reverts.

Reason:

Only the seller owns dispatch rights.

---

### Dispatch Before Order Creation

Attempt:

markDispatched()

Invalid orderId.

Expected Result:

Transaction reverts.

---

### Dispatch Twice

Seller dispatches successfully.

Seller immediately dispatches again.

Expected Result:

Transaction reverts.

---

### Dispatch After Deadline

Seller dispatches after dispatch timeout.

Expected Result:

Transaction reverts.

---

### Dispatch Wrong Order Status

Attempt dispatch after:

* COMPLETED
* REFUNDED
* DISPUTED

Expected Result:

Transaction reverts.

---

# Delivery Claim

---

### Delivery Claim Before Dispatch

Seller calls:

markDeliveryClaimed()

Expected Result:

Transaction reverts.

---

### Delivery Claim Twice

Expected Result:

Transaction reverts.

---

### Buyer Attempts Delivery Claim

Expected Result:

Transaction reverts.

---

### Delivery Claim After Completed Order

Expected Result:

Transaction reverts.

---

# Buyer Confirmation

---

### Confirm Before Delivery Claim

Buyer confirms delivery before seller has claimed delivery.

Expected Result:

Transaction reverts.

---

### Confirm Twice

Buyer confirms.

Immediately confirms again.

Expected Result:

Transaction reverts.

---

### Seller Attempts Confirmation

Expected Result:

Transaction reverts.

---

### Confirm Completed Order

Expected Result:

Transaction reverts.

---

# Seller Timeout Claim

---

### Claim Before Seven Days

Seller calls:

sellerClaimAfterTimeout()

before timeout expires.

Expected Result:

Transaction reverts.

---

### Claim Without Delivery Claim

Seller skips:

markDeliveryClaimed()

Expected Result:

Transaction reverts.

---

### Buyer Calls Timeout Function

Expected Result:

Transaction reverts.

---

### Claim Twice

Expected Result:

Transaction reverts.

---

# Buyer Refund Timeout

---

### Refund Before Dispatch Deadline

Buyer calls:

buyerRefundAfterTimeout()

Expected Result:

Transaction reverts.

---

### Seller Calls Refund

Expected Result:

Transaction reverts.

---

### Refund After Dispatch

Expected Result:

Transaction reverts.

---

### Refund Completed Order

Expected Result:

Transaction reverts.

---

# Dispute Workflow

---

### Raise Dispute Before Delivery Claim

Expected Result:

Transaction reverts.

---

### Raise Dispute After Completion

Expected Result:

Transaction reverts.

---

### Raise Dispute Twice

Expected Result:

Transaction reverts.

---

### Seller Raises Dispute

Expected Result:

Transaction reverts.

Only buyers should initiate disputes.

---

### Invalid Order ID

Expected Result:

Transaction reverts.

---

# SellerBond Edge Cases

---

### Deposit Less Than Minimum Bond

Expected Result:

Transaction reverts.

---

### Deposit Bond Twice

Expected Result:

Transaction reverts.

---

### Withdraw Without Bond

Expected Result:

Transaction reverts.

---

### Slash More Than Bond

Expected Result:

Transaction reverts.

---

### Slash Inactive Seller

Expected Result:

Transaction reverts.

---

### Non-DisputeManager Calls slashSeller()

Expected Result:

Transaction reverts.

---

### Initialize Twice

Expected Result:

Transaction reverts.

---

# DisputeManager Edge Cases

---

### Stake Below Minimum

Expected Result:

Transaction reverts.

---

### Stake Twice

Expected Result:

Transaction reverts.

---

### Vote Before Juror Assignment

Expected Result:

Transaction reverts.

---

### Vote Twice

Expected Result:

Transaction reverts.

---

### Non-Juror Votes

Expected Result:

Transaction reverts.

---

### Non-Assigned Juror Votes

Expected Result:

Transaction reverts.

---

### Vote After Deadline

Expected Result:

Transaction reverts.

---

### Finalize Before Voting Ends

Expected Result:

Transaction reverts.

---

### Finalize Twice

Expected Result:

Transaction reverts.

---

### Assign Wrong Number of Jurors

Expected Result:

Transaction reverts.

The protocol expects exactly three jurors.

---

### Assign Inactive Juror

Expected Result:

Transaction reverts.

---

### Initialize Twice

Expected Result:

Transaction reverts.

---

# Treasury Edge Cases

---

### Withdraw by Non-Owner

Expected Result:

Transaction reverts.

---

### Withdraw More Than Balance

Expected Result:

Transaction reverts.

---

### Withdraw to Zero Address

Expected Result:

Transaction reverts.

---

### Receive ETH Directly

If Treasury only accepts protocol transfers, verify whether direct ETH transfers are accepted or rejected according to the implementation.

---

# Initialization Edge Cases

Every protocol contract should reject multiple initialization attempts.

Verify:

MarketplaceEscrow

SellerBond

DisputeManager

Expected Result:

Only the first initialization succeeds.

---

# Cross-Contract Validation

Attempt to call privileged functions from externally owned accounts.

Examples:

resolveDispute()

slashSeller()

createDispute()

Expected Result:

Transaction reverts.

Only authorized contracts should execute these operations.

---

# State Machine Validation

Verify that orders never skip required states.

Invalid transitions include:

```text
FUNDS_LOCKED

↓

COMPLETED
```

```text
FUNDS_LOCKED

↓

DELIVERY_CLAIMED
```

```text
DISPATCHED

↓

REFUNDED
```

```text
COMPLETED

↓

DISPUTED
```

Every invalid transition must revert.

---

# Financial Validation

Verify that protocol funds remain correct after every operation.

Checks include:

* Escrow balance never becomes negative.
* Seller receives the correct payout.
* Treasury receives the correct platform fee.
* Buyer refunds equal the escrowed amount.
* Seller bond decreases only after valid slashing.

---

# Event Validation

Verify that failed transactions do **not** emit events.

Only successful state transitions should generate events.

---

# Gas and Stress Testing (Recommended)

Although not mandatory during functional testing, the following scenarios should be considered:

* Multiple sellers creating concurrent orders.
* Multiple disputes active simultaneously.
* Large juror participation.
* High transaction throughput.
* Long-running protocol interactions.

These tests help identify scalability concerns before production deployment.

---

# Security Validation Checklist

Before deploying the protocol to a public network, verify:

✅ Unauthorized access is rejected.

✅ Invalid state transitions revert.

✅ Double execution is impossible.

✅ Ether cannot be trapped.

✅ Escrow balances remain correct.

✅ Treasury accounting remains accurate.

✅ Seller collateral cannot be bypassed.

✅ Juror voting remains consistent.

✅ Initialization is one-time only.

✅ Cross-contract permissions are enforced.

---

# Security Model

## Introduction

The Marketplace DAO Protocol has been designed with security as a core architectural principle. Since the protocol manages user funds through smart contracts, every critical operation is protected using layered security mechanisms that enforce access control, valid state transitions, and secure cross-contract communication.

Rather than relying on trust in a centralized authority, the protocol relies on deterministic smart contract logic to protect marketplace participants.

---

# Security Objectives

The protocol aims to achieve the following security goals:

* Protect buyer funds while held in escrow.
* Ensure sellers cannot withdraw funds prematurely.
* Prevent unauthorized contract interactions.
* Enforce valid order state transitions.
* Protect against reentrancy attacks.
* Restrict privileged operations to authorized roles.
* Maintain immutable transaction history.
* Preserve protocol integrity during failures.

---

# Security Layers

The protocol applies multiple security layers instead of relying on a single mechanism.

## Access Control

Privileged operations are protected through role-based modifiers.

Examples include:

* `onlyOwner`
* `onlyBuyer`
* `onlySeller`
* `onlyDisputeManager`
* `onlyMarketplaceEscrow`
* `onlyInitialized`

These modifiers ensure that sensitive functions can only be executed by the intended actor.

---

## State Machine Protection

Orders must follow a predefined lifecycle.

```text id="wllsv9"
FUNDS_LOCKED
      │
      ▼
DISPATCHED
      │
      ▼
DELIVERY_CLAIMED
      │
      ├─────────────► COMPLETED
      │
      └─────────────► DISPUTED
                         │
                         ▼
              REFUNDED / COMPLETED
```

Invalid state transitions are rejected.

---

## Reentrancy Protection

Functions involving Ether transfers use OpenZeppelin's `ReentrancyGuard` to prevent reentrancy attacks during fund transfers.

---

## Initialization Protection

Each contract uses a one-time initialization mechanism.

Once initialized, contract dependencies cannot be modified.

This prevents malicious reconfiguration after deployment.

---

## Cross-Contract Authorization

Contracts communicate only through predefined interfaces.

Critical functions such as dispute resolution and seller slashing are restricted to authorized contracts.

Example:

```text id="5zmv8s"
MarketplaceEscrow
        │
        ▼
DisputeManager
        │
        ▼
SellerBond
```

External accounts cannot directly invoke privileged cross-contract functions.

---

## Escrow Security

Buyer funds remain locked inside the MarketplaceEscrow contract until one of the following occurs:

* Buyer confirms delivery.
* Seller claims after timeout.
* A dispute is resolved.

Neither buyers nor sellers can bypass escrow rules.

---

## Seller Accountability

Every seller must maintain a security bond before participating in the marketplace.

If a dispute is resolved against the seller, part of the bond may be slashed.

This creates an economic incentive for honest participation.

---

## Treasury Protection

Protocol fees are transferred to a dedicated Treasury contract.

Treasury funds remain isolated from marketplace business logic, reducing the attack surface and simplifying accounting.

---

# Trust Assumptions

The protocol assumes:

* Ethereum executes smart contracts correctly.
* Users control their wallet private keys.
* IPFS content remains available through pinning.
* Off-chain marketplace metadata is managed independently of on-chain financial operations.

---

# Security Summary

The Marketplace DAO Protocol combines role-based access control, deterministic state transitions, secure cross-contract communication, escrow protection, seller collateral, and OpenZeppelin security modules to provide a robust foundation for decentralized marketplace operations.

These mechanisms work together to protect protocol funds, maintain marketplace integrity, and ensure transparent execution of business rules.








