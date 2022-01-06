// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import '../interface/IMasterChefModule.sol';

abstract contract MasterChefModule is IMasterChefModule {
  IERC20 public immutable override sushi;
  IMasterChef public override masterChef;
  uint256 public constant PRECISION = 1e18;

  struct RewardPoolInfo {
    uint256 accSushiPerShare;
    uint256 lastRewardBlock;
  }
  mapping(uint256 => RewardPoolInfo) public override rewardPoolInfo;

  constructor(IMasterChef _masterChef, IERC20 _sushi) {
    masterChef = _masterChef;
    sushi = _sushi;
  }

  function _pendingSushiReward(
    uint256 _pid,
    uint256 lpTokenAmount,
    uint256 sushiRewardDebt
  ) internal view returns (uint256) {
    RewardPoolInfo memory _poolInfo = rewardPoolInfo[_pid];
    uint256 _totalLPsupply = masterChef.userInfo(_pid, address(this)).amount;

    uint256 _accSushiPerShare = _poolInfo.accSushiPerShare;
    if (block.number > _poolInfo.lastRewardBlock && _totalLPsupply != 0) {
      uint256 reward = masterChef.pendingSushi(_pid, address(this));
      _accSushiPerShare += ((reward * PRECISION) / _totalLPsupply);
    }

    return (lpTokenAmount * _accSushiPerShare) / PRECISION - sushiRewardDebt;
  }

  function _toSushiMasterChef(
    bool deposit,
    uint256 _pid,
    uint256 _amount,
    uint256 _totalLPsupply
  ) internal returns (uint256 _accSushiPerShare, uint256 reward) {
    RewardPoolInfo storage _poolInfo = rewardPoolInfo[_pid];
    if (block.number <= _poolInfo.lastRewardBlock) {
      if (deposit) masterChef.deposit(_pid, _amount);
      else masterChef.withdraw(_pid, _amount);
      return (_poolInfo.accSushiPerShare, 0);
    } else {
      uint256 balance0 = sushi.balanceOf(address(this));
      if (deposit) masterChef.deposit(_pid, _amount);
      else masterChef.withdraw(_pid, _amount);
      uint256 balance1 = sushi.balanceOf(address(this));
      reward = balance1 - balance0;
    }
    _poolInfo.lastRewardBlock = block.number;
    if (_totalLPsupply > 0 && reward > 0) {
      _accSushiPerShare = _poolInfo.accSushiPerShare + ((reward * PRECISION) / _totalLPsupply);
      _poolInfo.accSushiPerShare = _accSushiPerShare;
      return (_accSushiPerShare, reward);
    } else {
      return (_poolInfo.accSushiPerShare, reward);
    }
  }

  function safeSushiTransfer(address _to, uint256 _amount) internal {
    uint256 sushiBal = sushi.balanceOf(address(this));
    if (_amount > sushiBal) {
      sushi.transfer(_to, sushiBal);
    } else {
      sushi.transfer(_to, _amount);
    }
  }
}
