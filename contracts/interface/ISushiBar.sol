// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

interface ISushiBar is IERC20 {
  function sushi() external view returns (IERC20);

  // Enter the bar. Pay some SUSHIs. Earn some shares.
  // Locks Sushi and mints xSushi
  function enter(uint256 _amount) external;

  // Leave the bar. Claim back your SUSHIs.
  // Unlocks the staked + gained Sushi and burns xSushi
  function leave(uint256 _share) external;
}
