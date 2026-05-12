# No-Show Yield Protocol (NSYP)

Convert service industry no-show rates into structured DeFi yield.

## Core Insight

15â€“30% of booked appointments at service businesses (dentists, hairstylists, auto repair) result in no-shows. This is an actuarially stable loss at portfolio scale â€” predictable variance that can be pooled, priced, and traded as yield.

## How It Works

### Layer 1: Deposit-Backed Booking
- Clients pay a refundable USDC deposit to book an appointment
- **Shows up**: deposit returned + loyalty tokens (NSYP-LOYAL)
- **No-shows**: deposit flows to the liquidity pool

### Layer 2: No-Show Insurance
- Businesses pay a fixed premium to insure against no-show revenue loss
- Premium = actuarial expected loss + spread (25-35% arbitrage)
- If a client no-shows, insurance covers the business's revenue loss
- The deposit covers the insurance payout, LP earns the spread

### Layer 3: LP Staking
- LPs deposit USDC into vaults
- Vaults underwrite no-show risk across pooled businesses
- Returns come from: captured deposits + insurance premiums
- LP tokens (nsypUSDC) are redeemable for underlying + yield

## Contract Architecture

```
NSYPFactory.sol         â€” Deploys and manages business vaults
BusinessVault.sol        â€” Per-business deposit pool
InsurancePool.sol        â€” Cross-business insurance pool
NsypUSDCToken.sol        â€” LP share token (ERC-4626)
NsypLoyaltyToken.sol     â€” Client loyalty token
NsypOracle.sol           â€” No-show verification oracle
```

## Key Mechanics

### Deposit Pricing
```
deposit = service_price * (1 + no_show_rate)
```
Where `no_show_rate` is dynamically updated per business based on historical data.

### Insurance Premium
```
premium = expected_loss + (expected_loss * spread)
spread = 0.25 to 0.35 (configurable by pool governance)
```

### LP Returns
```
lp_yield = (captured_deposits + premiums) / total_lp_capital
```

## Oracle Design

No-show verification is the critical trust point. Options:

1. **Business Self-Reporting**: Business marks appointment as show/no-show. Requires staking/slashing mechanism to prevent fraud.
2. **API Integration**: Read-only API keys from booking software (Calendly, Acuity, Square Appointments). Signed response proves appointment status.
3. **Dual Attestation**: Both business and client confirm. Disputes resolved by DAO or arbitrator.

## Tokenomics

| Token | Purpose | Supply |
|-------|---------|--------|
| nsypUSDC | LP share token (ERC-4626) | Dynamic (minted on deposit) |
| NSYP-LOYAL | Client loyalty points | Minted per show |
| NSYP | Governance token | Fixed supply (100M) |

## Risk Analysis

| Risk | Mitigation |
|------|-----------|
| Oracle manipulation | Multi-source attestation, staking, dispute window |
| Mass no-show event | Pool diversification, max exposure per business |
| LP liquidity crunch | Gradual withdrawal, emergency pause |
| Business default | Insurance pool reserve requirements |

## Deployment Targets

- Base (low gas, Coinbase ecosystem)
- Arbitrum (deep DeFi liquidity)
- Polygon (cheapest gas for onboarding)

## Revenue Model

- Protocol fee: 10% of insurance premiums
- LP performance fee: 15% of yield above baseline
- Business onboarding fee: one-time $50 USDC
