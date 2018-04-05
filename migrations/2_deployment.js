var BloxToken = artifacts.require("BloxMovieToken")

module.exports = function(deployer){
  deployer.deploy(BloxToken,0x8e49a92e1d3079d608f198b914b6257df6f79bda,
    "JurassicPark",
    2000000,
    2000000,
    "JP",
    0
  );
}
