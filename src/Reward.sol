// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/MerkleProofUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./interfaces/IERC20AssetManagement.sol";
import "./interfaces/IRewardable.sol";

import "./AssetManagementSupported.sol";

/**
 * calc & submit reward
 */
contract Reward is Initializable, IRewardable, ContextUpgradeable, OwnableUpgradeable, AssetManagementSupported {
	using MerkleProofUpgradeable for bytes32[];
	bytes32 private _rewardRoot;
	/**
	 * @dev user => prize
	 */
	mapping(address => uint) internal _distributed;

	address internal _tournament;

	function initialize(address tournament_) public initializer {
		_tournament = tournament_;
	}

	function __Reward_init(address tournament_) internal onlyInitializing {
		__Context_init_unchained();
		__Reward_init_unchained(tournament_);
	}

	function __Reward_init_unchained(address tournament_) internal onlyInitializing {
		_tournament = tournament_;
	}

	function tournament() public view returns (address) {
		return _tournament;
	}

	function distributed(address player) public view returns (uint) {
		return _distributed[player];
	}

	function rewardRootState() external view returns (bytes32) {
		return _rewardRoot;
	}

	function submitReward(bytes32 root_) public onlyOwner {
		_rewardRoot = root_;
	}

	function claimReward(bytes memory data_) public {
		(bytes32[] memory proofs, uint256 rank, address currency, uint256 total) = abi.decode(
			data_,
			(bytes32[], uint256, address, uint256)
		);
		address player = _msgSender();
		require(_distributed[player] == 0, "Reward: distributed");
		bytes32 leaf = keccak256(abi.encode(player, rank, currency, total));
		bool isValidProof = proofs.verify(_rewardRoot, leaf);
		require(isValidProof, "Reward: invalid proof");
		_distributed[player] = rank;

		address bucket = address(this);
		IERC20AssetManagement(assetManagement()).withdrawERC20(bucket, player, currency, total);
		emit ClaimReward(player, rank, currency, total);
	}

	function supportsInterface(
		bytes4 interfaceId
	) public view virtual override(AssetManagementSupported, IERC165Upgradeable) returns (bool) {
		return super.supportsInterface(interfaceId) || interfaceId == type(IRewardable).interfaceId;
	}
}
