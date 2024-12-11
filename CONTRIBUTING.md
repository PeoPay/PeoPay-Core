# Contributing to PeoPay-Core

We welcome contributions from the community! Whether you’re fixing a bug, adding a new feature, or improving documentation, your help is valuable to us. This document provides guidelines to ensure a smooth contribution experience.

## Table of Contents
- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Code Style and Standards](#code-style-and-standards)
- [Testing](#testing)
- [Pull Requests](#pull-requests)
- [Issues and Feature Requests](#issues-and-feature-requests)
- [Security](#security)
- [License](#license)

## Getting Started
1. **Fork the Repository:**  
   Click the “Fork” button at the top right of this page to create a personal copy of the PeoPay-Core repository.

2. **Clone Your Fork:**  
   ```bash
   git clone https://github.com/PeoPay/PeoPay-Core.git
   cd PeoPay-Core
   ```

3. **Create a Branch:**  
   For new features or bug fixes, create a dedicated branch:
   ```bash
   git checkout -b feature/my-new-feature
   ```
   
   Choose a descriptive branch name to make it clear what the branch is about.

## Development Environment
- **Node.js & npm:**  
  Install Node.js (LTS recommended) and npm from [Node.js downloads](https://nodejs.org/en/download/).
  
- **Dependencies:**  
  Install all required dependencies:
  ```bash
  npm install
  ```

- **Hardhat:**  
  We use Hardhat for compiling, testing, and deploying smart contracts. See [`hardhat.config.js`](../hardhat.config.js) for configuration details.

- **Environment Variables:**  
  Create a `.env` file (based on `.env.example`) for storing private keys, API keys, and RPC URLs:
  ```bash
  cp .env.example .env
  ```

## Code Style and Standards
- **Solidity Code:**  
  - Follow [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html) recommendations.
  - Use Natspec comments (`@notice`, `@dev`, `@param`, `@return`) for functions and contracts to provide clarity.
  - Keep contracts modular and follow the Single Responsibility Principle.

- **JavaScript/TypeScript:**  
  - Use descriptive variable names.
  - Add inline comments to explain complex logic.
  - Maintain a consistent formatting style. Consider using Prettier or ESLint to enforce consistency.

## Testing
- **Unit Tests:**  
  All new code should be covered by unit tests. Place test files under `test/` following the naming convention `<contractname>.test.js`.

- **Run Tests:**  
  ```bash
  npx hardhat test
  ```

- **Coverage:**  
  Ensure your changes do not reduce coverage:
  ```bash
  npx hardhat coverage
  ```

- **Property-Based Testing (Optional):**  
  If you add property-based tests (e.g., using Echidna), place them in `test/echidna/` and ensure they run cleanly.

## Pull Requests
1. **Update Your Branch:**  
   Keep your branch updated with the main branch:
   ```bash
   git fetch upstream
   git merge upstream/main
   ```

2. **Commit Message Quality:**  
   Write clear and concise commit messages. Example:
   ```bash
   git commit -m "Add time-based bonus calculation to Staking contract"
   ```

3. **Open a Pull Request (PR):**  
   Go to your fork on GitHub and open a PR against the main PeoPay-Core repository. Provide a descriptive title and a summary explaining:
   - What problem does it solve or what feature does it add?
   - Why is it needed?
   - Any special considerations or backward-incompatible changes?

4. **Review Process:**  
   The maintainers will review your PR, ask questions, or request changes. Please respond promptly.

## Issues and Feature Requests
- **Bug Reports:**  
  Use [GitHub Issues](https://github.com/PeoPay/PeoPay-Core/issues) to report bugs. Include steps to reproduce, expected vs. actual behavior, and relevant logs.

- **Feature Requests:**  
  Suggest new features or improvements via GitHub Issues. Clearly describe the enhancement and its potential impact.

## Security
- **Vulnerabilities:**  
  If you discover a vulnerability, please follow our security guidelines. Do not post it publicly. Instead, contact the team directly (instructions in `SECURITY.md`).

## License
By contributing, you agree that your contributions will be licensed under the [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

---

Thank you for contributing to PeoPay-Core! Your involvement helps strengthen the ecosystem and fosters innovation. If you have any questions, don’t hesitate to reach out through GitHub Issues or our community channels.
