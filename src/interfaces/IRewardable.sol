// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

interface IRewardable is IERC165Upgradeable {
	event ClaimReward(address indexed player, uint256 indexed rank, address indexed currency, uint256 total);

	/**
	 * Rewards have been distributed to player
	 * @param player address
	 */
	function distributed(address player) external view returns (uint256);

	/**
	 * claim rewards
	 * @param data_ payload
	 */
	function claimReward(bytes memory data_) external;
}
