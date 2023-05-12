// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

interface ITime is IERC165Upgradeable {
	event TimeChanged(int64 _openning, int64 _closing);

	function openningTime() external view returns (int64);

	function closingTime() external view returns (int64);
}
