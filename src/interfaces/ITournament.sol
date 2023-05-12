// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

import "../helpers/ITime.sol";

interface ITournament is IERC165Upgradeable, ITime {
	/**
	 * Creator
	 */
	function owner() external view returns (address);

	function reward() external view returns (address);
}
