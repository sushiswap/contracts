// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

library SafeCast {
  function to248(uint256 x) internal pure returns (uint248 y) {
    require(x <= type(uint248).max);

    y = uint248(x);
  }

  function to128(uint256 x) internal pure returns (uint128 y) {
    require(x <= type(uint128).max);

    y = uint128(x);
  }

  function to96(uint256 x) internal pure returns (uint96 y) {
    require(x <= type(uint96).max);

    y = uint96(x);
  }

  function to64(uint256 x) internal pure returns (uint64 y) {
    require(x <= type(uint64).max);

    y = uint64(x);
  }

  function to32(uint256 x) internal pure returns (uint32 y) {
    require(x <= type(uint32).max);

    y = uint32(x);
  }
}
