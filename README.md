# PeoPay-Core
[![License](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Docs](https://img.shields.io/badge/docs-peopay.io-informational)](https://docs.peopay.io/)
[![Website](https://img.shields.io/badge/website-peopay.io-blue)](https://peopay.io/)
[![Network: Polygon](https://img.shields.io/badge/network-polygon-8247E5?logo=polygon)](https://polygon.technology/)
[![ERC-20 Standard](https://img.shields.io/badge/ERC-20-blue.svg)](https://eips.ethereum.org/EIPS/eip-20)
[![Made with Foundry](https://img.shields.io/badge/made%20with-foundry-blueviolet.svg)](https://book.getfoundry.sh/)
[![Uses OpenZeppelin Contracts](https://img.shields.io/badge/OpenZeppelin-Contracts-brightgreen.svg)](https://openzeppelin.com/contracts/)
[![Verified on Polygonscan](https://img.shields.io/badge/verified%20on-polygonscan-blue.svg)](https://polygonscan.com/)

**PeoPay-Core** is the foundational repository for the [PeoPay](https://peopay.io/) ecosystem. It contains the core smart contracts and logic for the PeoCoin token (PEO), staking, governance, conversion (crypto-to-mobile), and the Dynamic Contribution Scoring (DCS) system. These contracts form a decentralized infrastructure that supports staking rewards, governance proposals, transaction conversions, and a flexible scoring mechanism to reward active contributors.

For a detailed technical overview and developer guides, refer to the official [PeoPay Documentation](https://docs.peopay.io/).

---

## Overview

- **PeoCoin (PEO):**  
  An ERC-20 token serving as the primary utility token in the PeoPay ecosystem. Mintable, burnable, and managed by an owner account.

- **Staking:**  
  Enables users to stake PEO tokens to earn rewards over time. Includes lock periods, APY calculations, and optional tier multipliers.

- **Governance:**  
  Empowers PEO holders to propose and vote on ecosystem changes. Voting power is determined by DCS scores to reward active participants.

- **DCS (Dynamic Contribution Scoring):**  
  Computes a user’s contribution score based on PEO balance, staking duration, governance participation, and other metrics. Scores influence staking rewards and governance voting power.

- **Conversion (Crypto-to-Mobile):**  
  Facilitates off-chain conversion of PEO to mobile money. Users request conversions, and the backend service confirms them, enabling seamless integration with traditional financial systems.

---

## Repository Structure

```plaintext
PeoPay-Core/
├── src/                          # Core contracts
│   ├── PeoCoin.sol               # PEO ERC-20 token
│   ├── Staking.sol               # Staking logic and rewards
│   ├── Governance.sol            # Governance proposals and voting
│   ├── Conversion.sol            # Crypto-to-mobile conversion logic
│   ├── DCS.sol                   # Dynamic Contribution Scoring (DCS)
│   └── interfaces/               # Interface definitions
│       ├── IPeoCoin.sol
│       ├── IDCS.sol
│       └── IStaking.sol
├── test/                         # Foundry test files
│   ├── PeoCoin.t.sol
│   ├── Staking.t.sol
│   ├── Governance.t.sol
│   ├── Conversion.t.sol
│   └── DCS.t.sol
├── script/                       # Foundry deployment scripts
│   ├── DeployPeoCoin.s.sol
│   ├── DeployStaking.s.sol
│   ├── DeployDCS.s.sol
│   ├── DeployGovernance.s.sol
│   └── DeployConversion.s.sol
├── foundry.toml                  # Foundry configuration
├── .env.example                  # Example environment variable file
├── README.md                     # This README
```

---

## Prerequisites

- **Foundry:** A fast, portable, and modular development framework for Ethereum.  
  Install Foundry by running:
  ```bash
  curl -L https://foundry.paradigm.xyz | bash
  foundryup
  ```

- **A Test Network & Provider:** Use [Infura](https://infura.io/) or [Alchemy](https://www.alchemy.com/) for RPC endpoints.

---

## Environment Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/PeoPay/PeoPay-Core.git
   cd PeoPay-Core
   ```

2. Install dependencies:
   ```bash
   forge install
   ```

3. Configure the `.env` file for deployment:
   ```bash
   cp .env.example .env
   ```
   Fill in the following fields:
   - `PRIVATE_KEY`: Your wallet's private key.
   - `RPC_URL`: The RPC endpoint for your desired network.
   - `ETHERSCAN_API_KEY`: API key for contract verification (optional).

---

## Compilation & Testing

### Compile Contracts
Run the following command to compile the contracts:
```bash
forge build
```

### Run Tests
Run the provided test suite using Foundry:
```bash
forge test
```

### Advanced Testing
- **Gas Usage Analysis**:
  ```bash
  forge test --gas-report
  ```
- **Verbose Output**:
  ```bash
  forge test -vvv
  ```

---

## Deployment

Deploy contracts using Foundry scripts. Update `script/*.s.sol` files with deployment parameters and run:

```bash
forge script script/DeployPeoCoin.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

To verify the deployed contracts on Etherscan:
```bash
forge verify-contract --chain-id <chain_id> --compiler-version <solc_version> <contract_address> <contract_path> --etherscan-api-key $ETHERSCAN_API_KEY
```

---

## Code Coverage

Generate a coverage report using `forge coverage`:
```bash
forge coverage
```

---

## Security & Audits

Before deploying to mainnet:
- Conduct a third-party audit.
- Use tools like `slither` and `mythril` for static analysis.
- Launch a bug bounty program.

---

## Contributing

1. Fork the repository and create a feature branch.
2. Write tests for new features or fixes.
3. Submit a pull request with a detailed description.

---

## Additional Resources

- **Website:** [peopay.io](https://peopay.io/)
- **Documentation:** [docs.peopay.io](https://docs.peopay.io/)

---

## Contact & 

- Open an issue for support or feature requests.