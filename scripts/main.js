const {Deploy} = require("./deploy")
const {Listen} = require("./listen")

async function mian(){

}







// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  