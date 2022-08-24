# Simple Stablecoin

This is a stable coin made from scratch using solidityⓂ️

## Initialization

```bash
npx hardhat run scripts/deploy.js

```
## General Overview
The structure is made by 4 smart contracts : 

- [PriceConsumerV3.sol](https://github.com/XabierOterino/Simple-Stablecoin/blob/main/contracts/PriceConsumerV3.sol): A price feed tracker that uses Chainlink Oracles

- [StableCoin](https://github.com/XabierOterino/Simple-Stablecoin/blob/main/contracts/StableCoin.sol): The base token contract

- [SupplyManager](https://github.com/XabierOterino/Simple-Stablecoin/blob/main/contracts/SupplyManager.sol): The contract the manages the supply and funds of the token

- [Treasury](https://github.com/XabierOterino/Simple-Stablecoin/blob/main/contracts/Treasury.sol): Contract that holds all the reserves available for the token 

## How it works

The funds that are going to back the stablecoin area deposited iun the treasury contract , where liquidity providers earn a reward for it. The APY is calculated using the same algorithm as Synthetix does. 

In the initialization of the project two security  thresholds are set up : Alert threshold and emergency threshold , to prevent the stable coin from going out from liquidity. The supply manager will mint and burn base tokens depending on the demand.

If someone wants some tokens will need to deposit ETH and the supply manager will mint the equivalent amount in dollars using the ETH/USD price feed aggregator. Furthermore , if someone wants to exchange its stablecoins back for ETH the reverse process will happen , the supply manager will  burn the tokens minted previusly and the equivalent ETH amount. After each operation the supplyManager checks if the stable coin is healthy.

The ratio tokenSupply()/totalAssets() should be grater than the alert threshold. If not , the contract emits an event
and request funds from the treasury. If the emergency Threshold was hit for some reason the whole stable coin would be paused till a healthy radio is recovered.

    