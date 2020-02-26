const Core = artifacts.require('Core');
const Rad = artifacts.require('RAD');
const RewardToken = artifacts.require('RewardToken');

const supply = (10**20).toString();
const name = "Rad";
const decimals = 18;
const symbol = "RAD";

const rewardSupply = (10).toString();
const rewardName = "Unique Reward Fungible Token";
const rewardDecimals = 0;
const rewardSymbol = "RWRD"

module.exports = async (deployer, accounts) => {
  deployer.deploy(Rad, supply, name, decimals, symbol);
  deployer.deploy(Core);
  let _core = await Core.deployed();
  let _addr = _core.address;
  deployer.deploy(RewardToken, rewardSupply, rewardName, rewardDecimals, rewardSymbol, _addr);
  
  
  
};
