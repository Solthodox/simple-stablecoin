# Simple Stablecoin

This is a stable coin made from scratch using solidityⓂ️

## Initialization

```bash
npx hardhat run scripts/deploy.js

```
## How it works
The structure is made by 4 smart contracts : 
    -[PriceConsumerV3.sol]("https://github.com/XabierOterino/Simple-Stablecoin/blob/main/contracts/PriceConsumerV3.sol"): A price feed tracker that uses Chainlink Oracles
    -[StableCoin]("https://github.com/XabierOterino/Simple-Stablecoin/blob/main/contracts/StableCoin.sol"): The base token contract
    -[SupplyManager]("https://github.com/XabierOterino/Simple-Stablecoin/blob/main/contracts/SupplyManager.sol"): The contract the manages the supply and funds of the token
    -[Treasuty]("https://github.com/XabierOterino/Simple-Stablecoin/blob/main/contracts/PriceConsumerV3.sol"): Contract that holds all the reserves available for the token 