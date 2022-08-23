const {ethers} = require("hardhat")
const {expect} = require("chai")

describe("SupplyManager" , ()=>{
  let supplyManager , stableCoin
  let deployer

  const toEther = (n) => {
    const ether = ethers.utils.parseUnits(n.toString() , "ether")
  }
  beforeEach(async()=>{
    const accouts = await ethers.getSigners
    deployer = accouts[0]
    const StableCoin = await hre.ethers.getContractFactory("StableCoin")
    const SupplyManager = await hre.ethers.getContractFactory("SupplyManager")
    stableCoin = await StableCoin.deploy("StableCoin" ,"STBC")
    supplyManager = await  StableCoin.deploy(stableCoin.address , 120 , 150);
    const tx = await stableCoin.setSupplyManager(supplyManager.address) 
    await tx.wait()
    const sendAssets = await deployer.sendTransaction({to : supplyManager.address , value : toEther(0.1)})
  })

  describe("Getting tokens" , () => {
    it("Deposits ETH correctly" , async()=>{
      const balanceEthBefore = await supplyManager.totalAssets()
      const deposit = await supplyManager.swapETH({value : toEther(0.1)})
      await deposit.wait()
      const balanceAfter = await supplyManager.totalAssets()
      expect(balanceAfter).to.be.greaterThan(balanceEthBefore)
      const tokenBalance = await stableCoin.balanceOf(deployer.address)
      expect(tokenBalance).to.be.greaterThan(0)
    })
  })




})