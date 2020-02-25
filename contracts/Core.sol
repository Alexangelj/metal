pragma solidity ^0.6.2;

/*
Title: RAD: Reputation and Achievement DAPP
Description: Posters can create, 'post', Microbounties which are then claimed by Claimants.
             The microbounty rewards used in this demo are strings which are mapped to the claimant's address.
             Posters have analytics to see how many users have claimed a microbounty.
             We call them microbounties because the criteria is easy to meet (micro), 
             and they drive user engagement which is beneficial to the poster (bounty).

Authors: Brock Smedley and Alexander Angel
.*/

abstract contract EIP20 {
    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address _owner) virtual external returns(uint256);
}


abstract contract ICore {

    enum CheckFunctionType { BALANCE }

    CheckFunctionType check;
    CheckFunctionType constant defaultCheck = CheckFunctionType.BALANCE;

    function setAchievement(address _addr, CheckFunctionType _checkType, uint256 _threshold, bytes32 _reward) public virtual returns (uint256 id);
    function claim(bytes32 _reward) public virtual returns (bool success);

}


contract Core is ICore {

    function setCheckBalance() public {
        check = CheckFunctionType.BALANCE;
    } 

    function getCheck() public view returns (CheckFunctionType) {
        return check;
    }

    function getDefaultCheck() public view returns (CheckFunctionType) {
        return defaultCheck;
    }


    struct Achievement {
        uint256 id;
        address addr;
        CheckFunctionType checkType;
        uint256 threshold;
        bytes32 reward;
    }

    Achievement achievement;
    uint256 public achievementCounter;

    uint256 public testBal;
    bool public testCheck;

    mapping (bytes32 => Achievement) public achievements;
    mapping (uint256 => Achievement) public achievementsId;

    function getAchievementId(bytes32 _reward) public view returns (uint256 id) {
        return achievements[_reward].id;
    }

    function getAchievementAddr(bytes32 _reward) public view returns (address addr) {
        return achievements[_reward].addr;
    }

    function getAchievementCheck(bytes32 _reward) public view returns (CheckFunctionType) {
        return achievements[_reward].checkType;
    }

    function getAchievementThreshold(bytes32 _reward) public view returns (uint256 threshold) {
        return achievements[_reward].threshold;
    }

    function getAchievementReward(uint256 _id) public view returns (bytes32 reward) {
        return achievementsId[_id].reward;
    }

    /** 
     * @dev Set a bounty achievement 'reward'.
     * @param _addr Address of contract to check against.
     * @param _checkType Type (uint8) of criteria check a user has to fulfill to claim reward. 0 = BALANCE
     * @param _reward The bounty reward - just a string. Could be a hash, or a private key to a wallet.
     * @return id The unique identifier of the posted achievement bounty.
     */
    function setAchievement(
            address _addr,
            CheckFunctionType _checkType,
            uint256 _threshold, 
            bytes32 _reward
        ) public override returns (uint256 id) {
        // CHECKS

        // EFFECTS
        achievementCounter = achievementCounter + 1;
        achievement = Achievement(
            achievementCounter,
            _addr,
            _checkType,
            _threshold,
            _reward
        );

        // INTERACTIONS
        achievementsId[achievementCounter] = achievement;
        achievements[_reward] = achievement;
        return achievement.id;
    }


    function claim(bytes32 _reward) public override returns(bool success) {
        // CheckFunctionType type = achievements[_reward].checkType;

        
        if(achievements[_reward].checkType == defaultCheck) {
            
            // CHECKS
            EIP20 erc20 = EIP20(achievements[_reward].addr);
            uint256 bal = erc20.balanceOf(msg.sender);
            testBal = bal; // FIX
            require(bal >= achievements[_reward].threshold, 'User does not meet threshold');

            // EFFECTS
            

            // INTERACTIONS

            testCheck = true; // FIX
            return true;
        } else {
            testCheck = false; // FIX
            revert();
        }
    }
}