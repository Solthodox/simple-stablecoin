const {ethers} = require("hardhat")

exports.Listen = async function(contractInstance){
    console.log(`Listening to : ${contractInstance.address}`)
    contractInstance.on("alertThresholdHit", (timestamp)=>{
        console.log(`${timestamp} : ALERT THRESHOLD HIT!`)
        
    })

    contractInstance.on("emergencyThresholdHit" , (timestamp)=>{
        console.log(`${timestamp} : EMERGENCY THRESHOLD HIT! CONTRACT PAUSED...`)
    })
}