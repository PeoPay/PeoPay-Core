# PeoPay-Core

[![Build Status](https://img.shields.io/github/actions/workflow/status/YourUsername/PeoPay-Core/ci.yml?branch=main)](https://github.com/YourUsername/PeoPay-Core/actions)
[![Coverage Status](https://img.shields.io/coveralls/github/YourUsername/PeoPay-Core/main.svg)](https://coveralls.io/github/YourUsername/PeoPay-Core?branch=main)
[![License](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Docs](https://img.shields.io/badge/docs-peopay.io-informational)](https://docs.peopay.io/)
[![Website](https://img.shields.io/badge/website-peopay.io-blue)](https://peopay.io/)
[![Network: Polygon](https://img.shields.io/badge/network-polygon-8247E5?logo=polygon)](https://polygon.technology/)
[![ERC-20 Standard](https://img.shields.io/badge/ERC-20-blue.svg)](https://eips.ethereum.org/EIPS/eip-20)
[![Made with Hardhat](https://img.shields.io/badge/made%20with-hardhat-FF8800.svg)](https://hardhat.org/)
[![Uses OpenZeppelin Contracts](https://img.shields.io/badge/OpenZeppelin-Contracts-brightgreen.svg)](https://openzeppelin.com/contracts/)
[![Verified on Polygonscan](https://img.shields.io/badge/verified%20on-polygonscan-blue.svg)](https://polygonscan.com/)


**PeoPay-Core** is the foundational repository for the [PeoPay](https://peopay.io/) ecosystem. It contains the core smart contracts and logic for the PeoCoin token (PEO), staking, governance, conversion (crypto-to-mobile), and the Dynamic Contribution Scoring (DCS) system. These contracts together form a decentralized infrastructure that supports staking rewards, governance proposals, transaction conversions, and a flexible scoring mechanism to reward active contributors.

For a more detailed technical overview and developer guides, refer to the official [PeoPay Documentation](https://docs.peopay.io/).

## Overview

- **PeoCoin (PEO):**  
  An ERC-20 token that serves as the primary utility token in the PeoPay ecosystem. Mintable, burnable, and managed by an owner account.

- **Staking:**  
  Allows users to stake PEO tokens to earn rewards over time. Includes lock periods, APY calculations, and optional tier multipliers.

- **Governance:**  
  Enables PEO holders to propose and vote on changes in the ecosystem. Voting power is determined by DCS scores, ensuring that more engaged participants have greater influence.

- **DCS (Dynamic Contribution Scoring):**  
  Computes a user’s contribution score based on their PEO balance, staking duration, and governance participation (or other integrated metrics). Scores influence staking rewards and governance voting power.

- **Conversion (Crypto-to-Mobile):**  
  Facilitates the off-chain conversion of PEO to mobile money. Users request conversions, and the authorized backend service confirms them, enabling seamless integration with traditional financial infrastructures.

## Repository Structure

```plaintext
PeoPay-Core/
├── contracts/
│   ├── PeoCoin.sol           # PEO ERC-20 token
│   ├── Staking.sol           # Staking logic and rewards
│   ├── Governance.sol        # Governance proposals and voting
│   ├── Conversion.sol        # Crypto-to-mobile conversion logic
│   ├── DCS.sol               # Dynamic Contribution Scoring (DCS)
│   ├── mocks/
│   │   └── MockStaking.sol   # Mock staking for testing DCS or Governance
│   └── interfaces/           # Interface definitions
│       ├── IPeoCoin.sol
│       ├── IDCS.sol
│       └── IStaking.sol
├── test/                     # JavaScript test files for each contract
│   ├── peocoin.test.js
│   ├── staking.test.js
│   ├── governance.test.js
│   ├── conversion.test.js
│   ├── dcs.test.js
│   └── echidna/              # Echidna property-based tests (if any)
├── scripts/                  # Deployment and utility scripts
│   ├── deploy_peocoin.js
│   ├── deploy_staking.js
│   ├── deploy_dcs.js
│   ├── deploy_governance.js
│   └── deploy_conversion.js
├── .env.example              # Example environment variable file
├── hardhat.config.js         # Hardhat configuration
├── package.json              # Dependencies and scripts
└── README.md                 # This README
```

## Prerequisites

- **Node.js & npm**: Install from [Node.js downloads](https://nodejs.org/en/download/)
- **Hardhat**: A development environment for Ethereum.  
  ```bash
  npm install --save-dev hardhat
  ```
- **A Test Network & Provider**: For deployment, you can use [Infura](https://infura.io/) or [Alchemy](https://www.alchemy.com/).

## Environment Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/PeoPay/PeoPay-Core.git
   cd PeoPay-Core
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create an `.env` file based on `.env.example` and fill in your private keys, API keys, etc.:
   ```bash
   cp .env.example .env
   # Edit .env to include PRIVATE_KEY, INFURA_API_KEY, etc.
   ```

## Compilation & Testing

- Compile contracts:
  ```bash
  npx hardhat compile
  ```
  
- Run unit tests:
  ```bash
  npx hardhat test
  ```
  
All tests are located in the `test/` directory, covering PeoCoin, Staking, Governance, Conversion, and DCS functionality. Each test file includes inline comments for clarity.

## Code Coverage

Generate a coverage report to ensure comprehensive testing:
```bash
npx hardhat coverage
```

This command produces a coverage report under `coverage/`. Open `coverage/index.html` in your browser to view a detailed, color-coded coverage report.

## Deployment

You can deploy each contract using the provided scripts, for example:
```bash
npx hardhat run scripts/deploy_peocoin.js --network goerli
```

Make sure your `.env` file is set up with the appropriate RPC URLs and private keys.

## Security & Audits

Before mainnet deployment:

- Review code for best practices.
- Consider a third-party security audit.
- Use static analysis tools like `slither` or `mythril`.
- Employ a bug bounty program to encourage community scrutiny.

## Contributing

- Fork the repository and create a feature branch.
- Write tests for new features or bug fixes.
- Follow the existing coding style and comment patterns.
- Submit a pull request with a detailed description of your changes.

## License

This project is licensed under the [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html). See the `LICENSE` file for more details.

## Additional Resources

- **Website:** [peopay.io](https://peopay.io/)
- **Documentation:** [docs.peopay.io](https://docs.peopay.io/)

## Contact & Community

- For questions or support, open an issue in the repository.
- Join our community channels (Discord, Telegram, etc.) to discuss improvements and share feedback.
