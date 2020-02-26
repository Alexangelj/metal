const assert = require('assert').strict;
const Core = artifacts.require('Core');
const Rad = artifacts.require('RAD');
const RewardToken = artifacts.require('RewardToken');

contract('Core', (accounts) => {

  it('Test set achivement function and claim function', async () => {
    
    let Alice = accounts[0];

    // CONTRACTS
    let _core = await Core.deployed();

    let _rad = await Rad.deployed();
    let _rewardContract = await RewardToken.deployed();
    // VARIABLES
    // Check 0 = BALANCE
    let _check = (0).toString();
    let _threshold = (10**19).toString()
    let _reward = await web3.utils.asciiToHex("Own 10 RAD");
    let _secret = await web3.utils.hexToBytes(await web3.utils.asciiToHex("Password"));

    // Transfer Reward Tokens to Core
    let _transferReward = await _rewardContract.transfer(_core.address, (10).toString());

    // SET ACHIEVEMENT FUNCTION
    let _set = await _core.setAchievement(_rad.address, _check, _threshold, _reward, _rewardContract.address);

    // UNIT TESTS
    let _counter = (await _core.achievementCounter()).toString();
    assert.strictEqual(_counter, "1", 'Id should match');
    
    let _achievementId = (await _core.getAchievementId(_reward)).toString();
    assert.strictEqual(_achievementId, _counter, 'Id should match achievement')

    let _achievementCheck = (await _core.getAchievementCheck(_reward)).toString();
    assert.strictEqual(_achievementCheck, _check, 'Achievement check should match param _check');

    let _achievementAddr = (await _core.getAchievementAddr(_reward)).toString();
    assert.strictEqual(_achievementAddr, _rad.address, 'Achievement addr should match param _addr');

    let _achievementThreshold = (await _core.getAchievementThreshold(_reward)).toString();
    assert.strictEqual(_achievementThreshold, _threshold, 'Achievement addr should match param _addr');

    let _achievementReward = (await _core.getAchievementReward(_counter));
    console.log("achievement", _achievementReward, "reward", _reward);
    
    // SET USER SECRET FUNCTION
    let _setSecret = await _core.setSecret(_secret);

    // CLAIM ACHIEVEMENT FUNCTION
    let _claim = await _core.claim(_reward, {from: Alice});
    
    // UNIT TESTS
    let _testBal = (await _core.testBal()).toString();
    assert(_testBal >= _threshold, "User bal should be >= threshold");

    let _testCheck = await _core.testCheck();
    assert.strictEqual(_testCheck, true, 'Test check should be true');

    // GET USER ACHIEVEMENT BOOL AND TOKEN AMOUNT
    let _userAchievement = await _core.getUserAchievement(Alice, _secret, _counter);
    assert.strictEqual(_userAchievement, true, 'User should have achievement');

    let _userRewardBal = await _rewardContract.balanceOf(Alice);
    assert.strictEqual((_userRewardBal).toString(), "1", "User reward bal should be 1 == # claims");
  });
});
