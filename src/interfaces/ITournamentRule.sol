// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

interface ITournamentRule is IERC165Upgradeable {
	struct ClaimableData {
		address collection;
		uint256 tokenId;
	}

	event UpdateMetadataRuleURI(string url);

	/**
	 *
	 * @param leaf leaf of merkel tree
	 * @param owner who will receive the reward
	 * @param tokens tokens to be distributed
	 */
	event ClaimERC721(bytes32 indexed leaf, address indexed owner, ClaimableData[] tokens);

	/**
	 * metadata uri of tournament rule
	 */
	function metadataRuleURI() external view returns (string memory);

	/**
	 * Total reward of the tournament
	 */
	function totalReward() external view returns (uint256);

	function claimToken(bytes memory _data) external;
}
