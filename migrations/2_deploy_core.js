const Core = artifacts.require("Core");
const Rad = artifacts.require('RAD');

const supply = (10**20).toString();
const name = "Rad";
const decimals = 18;
const symbol = "RAD";

module.exports = function(deployer) {
  deployer.deploy(Rad, supply, name, decimals, symbol)
  deployer.deploy(Core);
};
