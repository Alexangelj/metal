const assert = require('assert').strict;
const Core = artifacts.require("Core");
const Rad = artifacts.require('RAD');

contract('Core', (accounts) => {

  it('Test set achivement function and claim function', async () => {
    // CONTRACTS
    let _core = await Core.deployed();
    let _rad = await Rad.deployed();

    // VARIABLES
    // Check 0 = BALANCE
    let _check = (0).toString();
    let _threshold = (10**19).toString()
    let _reward = await web3.utils.asciiToHex("Own 10 RAD");

    // SET ACHIEVEMENT FUNCTION
    let _set = await _core.setAchievement(_rad.address, _check, _threshold, _reward);

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
    
    // CLAIM ACHIEVEMENT FUNCTION
    let _claim = await _core.claim(_reward);
    
    // UNIT TESTS
    let _testBal = (await _core.testBal()).toString();
    assert(_testBal >= _threshold, "User bal should be >= threshold");


    let _testCheck = await _core.testCheck();
    assert.strictEqual(_testCheck, true, 'Test check should be true');
  });
});
