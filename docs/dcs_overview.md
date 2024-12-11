# Dynamic Contribution Scoring (DCS)

## Overview
Dynamic Contribution Scoring (DCS) is an innovative mechanism designed to evaluate a user’s participation and contribution within a decentralized ecosystem. This scoring system provides a fair and transparent way to reward users based on their token holdings, staking behavior, and the duration of their staking activities. It is particularly useful for governance or rewards contracts where weighted voting or benefit distribution is required.

The DCS system is implemented as a smart contract, relying on external data from token and staking contracts to compute scores. This ensures that the scoring process is dynamic, data-driven, and adaptable to changes in user activity or community priorities.

---

## Key Components

### 1. Token Holdings
Token holdings represent the balance of a specific token (PeoCoin, in this case) that a user owns. These holdings are directly retrieved from the PeoCoin contract and form one of the foundational inputs for the DCS score.

### 2. Staked Amounts
Staking refers to locking tokens in a staking contract to support the network or participate in ecosystem activities. The DCS system considers the total amount staked by a user as another significant factor in the scoring process.

### 3. Staking Duration
The length of time for which tokens are staked plays a crucial role in the DCS calculation. Longer staking periods reflect a higher level of commitment to the ecosystem and are rewarded with higher scores.

### 4. Weight Factors
The scoring formula includes three configurable weight factors:
- **Token Weight** (“tokenWeight”): Determines the relative importance of token balances in the score.
- **Stake Weight** (“stakeWeight”): Defines the impact of staked amounts.
- **Time Weight** (“timeWeight”): Specifies the contribution of staking duration to the score.

These weights are adjustable by the contract owner to align with governance goals or changing community needs.

---

## DCS Score Calculation
The DCS score is calculated using the following formula:

**Score = (tokenBalance * tokenWeight) + (stakedAmount * stakeWeight) + (stakedDurationInDays * timeWeight)**

Where:
- `tokenBalance`: The user’s token balance retrieved from the PeoCoin contract.
- `stakedAmount`: The total amount of tokens staked by the user.
- `stakedDurationInDays`: The number of days tokens have been staked, calculated as:
  
  **(block.timestamp - startTimestamp) / 1 day**

---

## Example Scenarios

### Example 1: A New Token Holder
- **Token Balance**: 100 PEO
- **Staked Amount**: 0 PEO
- **Staking Duration**: 0 days
- **Weights**: tokenWeight = 1, stakeWeight = 2, timeWeight = 1

**Score = (100 * 1) + (0 * 2) + (0 * 1) = 100**

### Example 2: A Committed Staker
- **Token Balance**: 50 PEO
- **Staked Amount**: 100 PEO
- **Staking Duration**: 30 days
- **Weights**: tokenWeight = 1, stakeWeight = 2, timeWeight = 1

**Score = (50 * 1) + (100 * 2) + (30 * 1) = 50 + 200 + 30 = 280**

### Example 3: A Long-Term Staker with Modest Tokens
- **Token Balance**: 10 PEO
- **Staked Amount**: 50 PEO
- **Staking Duration**: 180 days
- **Weights**: tokenWeight = 1, stakeWeight = 2, timeWeight = 1

**Score = (10 * 1) + (50 * 2) + (180 * 1) = 10 + 100 + 180 = 290**

---

## Benefits of DCS

1. **Fair Reward Distribution**: Rewards users proportionally based on their activity and contribution.
2. **Encourages Long-Term Commitment**: Incentivizes users to stake tokens for longer periods.
3. **Flexible Governance**: Weight factors can be adjusted to reflect the community’s evolving priorities.
4. **Transparency and Decentralization**: The scoring system is implemented as a public smart contract, ensuring transparency and trust.

---

## Conclusion
Dynamic Contribution Scoring is a powerful tool for fostering engagement and commitment within decentralized ecosystems. By incorporating token holdings, staking amounts, and duration into a unified score, DCS ensures a balanced and equitable reward system. This system not only strengthens user loyalty but also provides a robust framework for governance and benefit distribution. As communities continue to grow, DCS will play a vital role in aligning incentives and driving sustainable participation.

