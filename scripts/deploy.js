
const hre = require("hardhat");

exports.Deploy = async function () {
  const StableCoin = await hre.ethers.getContractFactory("StableCoin")
  const SupplyManager = await hre.ethers.getContractFactory("SupplyManager")
  const stableCoin = await StableCoin.deploy("StableCoin" ,"STBC")
  const supplyManager = await  StableCoin.deploy(stableCoin.address , 120 , 150);
  const tx = await stableCoin.setSupplyManager(supplyManager.address) 
  await tx.wait()
  return supplyManager

}

