const BasicWallet = artifacts.require("BasicWallet");

module.exports = function (deployer) {
  deployer.deploy(BasicWallet);
};
