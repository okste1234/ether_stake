// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IStakeEther {
    event WithdrawalSuccessful(
        address indexed user,
        uint256 indexed amount,
        uint256 indexed balance,
        uint256 when
    );
    event DepositSuccessful(address indexed user, uint256 indexed amount);
    event RewardAmount(address indexed user, uint256 indexed amount);

    function deposit() external payable;

    function withdraw(uint256 _amount) external;

    function checkReward() external view returns (uint256);

    function checkContractBalance() external view returns (uint);
}
