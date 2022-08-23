require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()

const MNEMONICS = process.env.MNEMONICS
const PRIVATE_KEY = process.env.PRIVATE_KEY
const INFURA_KEY = process.env.INFURA_KEY
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "mumbai",
  networks: {

    mumbai : {
      url: INFURA_KEY,
      accounts : [PRIVATE_KEY]
      
    }
  },
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: false,
        runs: 200
      }
    }
  },
};