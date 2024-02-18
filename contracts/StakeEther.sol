// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

error NOT_TIME_FOR_WITHDRAWAL();
error NOT_AUTHORISED_TO_CALL_FUNCTION();
error ZERO_VALUE();
error UNLOCKTIME_SHOULD_BE_FUTURE();
error DONT_HAVE_ENOUGH_FUNDS();
error NO_STAKE_NO_REWARD();

contract StakeEther {
    uint256 public unlockTime;
    address public owner;

    event WithdrawalSuccessful(
        address indexed user,
        uint256 indexed amount,
        uint256 indexed balance,
        uint256 when
    );
    event DepositSuccessful(address indexed user, uint256 indexed amount);
    event RewardAmount(address indexed user, uint256 indexed amount);

    mapping(address => uint) public stakers;

    mapping(address => uint256) public stakeTime;

    mapping(address => uint256) public rewards;

    constructor(uint _unlockTime) {
        if (block.timestamp > _unlockTime) {
            revert UNLOCKTIME_SHOULD_BE_FUTURE();
        }

        unlockTime = _unlockTime;
        owner = msg.sender;
    }

    function deposit() external payable {
        if (msg.value <= 0) {
            revert ZERO_VALUE();
        }

        stakeTime[msg.sender] = block.timestamp;

        stakers[msg.sender] = stakers[msg.sender] + msg.value;
        emit DepositSuccessful(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        if (block.timestamp < unlockTime) {
            revert NOT_TIME_FOR_WITHDRAWAL();
        }

        uint256 _userStakedBal = stakers[msg.sender];
        if (_userStakedBal <= 0) {
            revert DONT_HAVE_ENOUGH_FUNDS();
        }

        uint256 elapsedTime = block.timestamp - stakeTime[msg.sender];
        uint256 reward = (_userStakedBal * elapsedTime) / (60 * 100);

        stakers[msg.sender] = _userStakedBal + reward;

        stakers[msg.sender] = stakers[msg.sender] - _amount;

        rewards[msg.sender] = reward;

        payable(msg.sender).transfer(_amount);
        emit WithdrawalSuccessful(
            msg.sender,
            _amount,
            _userStakedBal,
            block.timestamp
        );
    }

    function checkReward() external view returns (uint256) {
        uint256 _userStakedBal = stakers[msg.sender];
        if (_userStakedBal <= 0) {
            revert NO_STAKE_NO_REWARD();
        }

        uint256 elapsedTime = block.timestamp - stakeTime[msg.sender];
        uint256 reward = (_userStakedBal * elapsedTime) / (60 * 100);

        return rewards[msg.sender] + reward;
    }

    function checkContractBalance() external view returns (uint) {
        return address(this).balance;
    }
}
