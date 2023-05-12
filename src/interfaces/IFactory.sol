// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

interface IFactory is IERC165Upgradeable {
	struct TourData {
		/**
		 * tournament structure
		 */
		address strategy;
		/**
		 * ticket name
		 */
		string name;
		/**
		 * owner of tournament
		 */
		address deployer;
		/**
		 * time to start tournament
		 */
		int64 startDate;
		/**
		 * time to end tournament
		 */
		int64 endDate;
		/**
		 * reserve params
		 */
		bytes params;
		/**
		 * deploy code
		 */
		uint256 nonce;
	}

	event TournamentCreated(address indexed deployer, uint256 indexed _nonce, address newTournament, bytes _data);

	function nonceOf(address deployer) external view returns (uint256);

	/**
	 * hold data & transfer to owner
	 */
	function assetManagement() external view returns (address);

	function createTournament(TourData memory _data) external;
}
