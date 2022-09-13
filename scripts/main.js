const {Deploy} = require("./deploy")
const {Listen} = require("./listen")

async function main(){
    Deploy()
      .then(Listen)
      .catch((error) => {
        console.error(error);
        process.exitCode = 1;
      });
      
}




main()