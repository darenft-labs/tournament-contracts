// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/MerkleProofUpgradeable.sol";

import "./interfaces/ITournamentRule.sol";
import "./interfaces/IERC20AssetManagement.sol";
import "./interfaces/IProxyTransferERC721.sol";
import "./interfaces/ITicketOffice.sol";

import "./AssetManagementSupported.sol";

contract TournamentRule is
	Initializable,
	ERC165Upgradeable,
	ContextUpgradeable,
	ITournamentRule,
	AssetManagementSupported
{
	using MerkleProofUpgradeable for bytes32[];

	bytes32 private _root;

	string private _metadataRuleURI;

	address private _ticketOffice;

	uint256 internal _nftPerTicket;

	/**
	 * leaf of the Merkle tree claimed
	 */
	mapping(bytes32 => address) private _claims;

	uint256 private _initialReward;
	uint256 private _percentRewardFromTicketOffice;

	/// @custom:oz-upgrades-unsafe-allow constructor
	constructor() {
		_disableInitializers();
	}

	function __TournamentRule_init(
		address ticketOffice_,
		uint256 nftPerTicket_,
		uint256 initialReward_,
		uint256 percentRewardFromTicketOffice_,
		string memory metadataRuleURI_
	) internal onlyInitializing {
		__Context_init_unchained();
		__ERC165_init_unchained();
		__TournamentRule_init_unchained(
			ticketOffice_,
			nftPerTicket_,
			initialReward_,
			percentRewardFromTicketOffice_,
			metadataRuleURI_
		);
	}

	function __TournamentRule_init_unchained(
		address ticketOffice_,
		uint256 nftPerTicket_,
		uint256 initialReward_,
		uint256 percentRewardFromTicketOffice_,
		string memory metadataRuleURI_
	) internal onlyInitializing {
		_ticketOffice = ticketOffice_;
		_nftPerTicket = nftPerTicket_;
		_initialReward = initialReward_;
		_percentRewardFromTicketOffice = percentRewardFromTicketOffice_;

		_setMetadataRuleURI(metadataRuleURI_);
	}

	function nftPerTicket() public view returns (uint256) {
		return _nftPerTicket;
	}

	function _setMetadataRuleURI(string memory newMetadata) internal {
		_metadataRuleURI = newMetadata;
		emit UpdateMetadataRuleURI(newMetadata);
	}

	function _setRoot(bytes32 newRoot) internal {
		_root = newRoot;
	}

	function root() public view returns (bytes32) {
		return _root;
	}

	/**
	 * burn ticket to NFT, distribute ERC721
	 * @param _data data to distribute
	 */
	function claimToken(bytes memory _data) public override {
		(bytes32[] memory proofs, ClaimableData[] memory tokens) = abi.decode(_data, (bytes32[], ClaimableData[]));
		bytes32 leaf = keccak256(abi.encode(tokens));
		require(_claims[leaf] != address(0), "Claimable: claimed");

		bool isValidProof = proofs.verify(root(), leaf);

		require(isValidProof, "Claimable: invalid proof");

		address _owner = _msgSender();
		_claims[leaf] = _owner;

		// lock 1 ticket -> transfer n NFT
		address ticket = address(this);
		IERC20AssetManagement(assetManagement()).depositERC20(address(this), _owner, ticket, 1);

		// distribute NFT to owner
		for (uint i = 0; i < tokens.length; i++) {
			IProxyTransferERC721(assetManagement()).proxyTransferERC721(
				address(this),
				_owner,
				tokens[i].collection,
				tokens[i].tokenId
			);
		}

		emit ClaimERC721(leaf, _owner, tokens);
	}

	function metadataRuleURI() public view override returns (string memory) {
		return _metadataRuleURI;
	}

	function ticketOffice() public view returns (address) {
		return _ticketOffice;
	}

	function initialReward() public view returns (uint) {
		return _initialReward;
	}

	function percentRewardFromTicketOffice() public view returns (uint256) {
		return _percentRewardFromTicketOffice;
	}

	function rewardFromTicketOffice() public view returns (uint256) {
		uint256 totalProfit = ITicketOffice(_ticketOffice).totalProfit();
		return (_percentRewardFromTicketOffice * totalProfit) / 100 ether;
	}

	function totalReward() external view override returns (uint256) {
		// reward ..
		return initialReward() + rewardFromTicketOffice();
	}

	function supportsInterface(
		bytes4 interfaceId
	) public view virtual override(AssetManagementSupported, ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
		return super.supportsInterface(interfaceId) || interfaceId == type(ITournamentRule).interfaceId;
	}
}
