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

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return success Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    
    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return success Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
}


abstract contract ICore {

    enum CheckFunctionType { BALANCE }

    CheckFunctionType check;
    CheckFunctionType constant defaultCheck = CheckFunctionType.BALANCE;

    function setSecret(bytes32 _secret) public virtual returns (bytes32 secret);
    function setAchievement(address _addr, CheckFunctionType _checkType, uint256 _threshold, bytes32 _reward, address _rewardAddr) public virtual returns (uint256 id);
    function claim(bytes32 _reward) public virtual;

}


contract Core is ICore {

    function setCheckBalance() public {
        check = CheckFunctionType.BALANCE;
    } 

    function getCheck() public view returns (CheckFunctionType) {
        return check;
    }

    function getDefaultCheck() public pure returns (CheckFunctionType) {
        return defaultCheck;
    }


    struct Achievement {
        uint256 id;
        address addr;
        CheckFunctionType checkType;
        uint256 threshold;
        bytes32 reward;
        address rewardAddr;
    }

    Achievement achievement;
    uint256 public achievementCounter;

    address public rewardTokenAddress;

    uint256 public testBal;
    bool public testCheck;

    mapping (address => bytes32) public userHash;
    mapping (address => mapping(uint256 => bool)) private userAchievement;
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

    function setSecret(bytes32 _secret) public override returns (bytes32 secret) {
        bytes memory x = abi.encodePacked(_secret);
        userHash[msg.sender] = keccak256(x);
        return keccak256(x);
    }

    function getSecret() public view returns (bytes32 secret) {
        return userHash[msg.sender];
    }

    function getUserAchievement(address _addr, bytes32 _secret, uint256 _id) public view returns (bool success) {
        // CHECKS
        bytes memory x = abi.encodePacked(_secret);
        require(keccak256(x) == userHash[_addr], 'Secret is incorrect');
        // EFFECTS
        // INTERACTIONS
        return userAchievement[msg.sender][_id];
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
            bytes32 _reward,
            address _rewardAddr
        ) public override returns (uint256 id) {
        // CHECKS

        // EFFECTS
        achievementCounter = achievementCounter + 1;
        achievement = Achievement(
            achievementCounter,
            _addr,
            _checkType,
            _threshold,
            _reward,
            _rewardAddr
        );

        // INTERACTIONS
        achievementsId[achievementCounter] = achievement;
        achievements[_reward] = achievement;
        return achievement.id;
    }


    function claim(bytes32 _reward) public override {
        if(achievements[_reward].checkType == defaultCheck) {
            // CHECKS
            EIP20 erc20 = EIP20(achievements[_reward].addr);
            EIP20 rewardToken = EIP20(achievements[_reward].rewardAddr);
            uint256 bal = erc20.balanceOf(msg.sender);
            testBal = bal; // FIX
            require(bal >= achievements[_reward].threshold, 'User does not meet threshold');

            // EFFECTS
            userAchievement[msg.sender][achievements[_reward].id] = true;

            // INTERACTIONS
            rewardToken.transfer(msg.sender, 1);
            
            testCheck = true; // FIX
        } else {
            testCheck = false; // FIX
            revert();
        }
    }
}