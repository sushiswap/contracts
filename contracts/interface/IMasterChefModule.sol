// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import './IMasterChef.sol';

interface IMasterChefModule {
  function sushi() external view returns (IERC20);

  function masterChef() external view returns (IMasterChef);

  function rewardPoolInfo(uint256 pid) external view returns (uint256 accSushiPerShare, uint256 sushiLastRewardBlock);
}
