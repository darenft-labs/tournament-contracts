// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165CheckerUpgradeable.sol";

import "./interfaces/IAssetManagement.sol";

import "hardhat/console.sol";

contract AssetManagement is AccessControlUpgradeable, IAssetManagement {
	using ERC165CheckerUpgradeable for address;
	using Address for address;

	bytes32 public constant TRANSFERABLE_ERC721_ROLE = keccak256("TRANSFERABLE_ERC721_ROLE");
	bytes32 public constant TRANSFERABLE_ERC20_ROLE = keccak256("TRANSFERABLE_ERC20_ROLE");

	mapping(address => mapping(address => uint256)) internal _erc20;
	mapping(address => mapping(uint256 => address)) internal _erc721;

	/// @custom:oz-upgrades-unsafe-allow constructor
	constructor() {
		_disableInitializers();
	}

	function initialize() public initializer {
		__AssetManagement_init();
	}

	function __AssetManagement_init() internal onlyInitializing {
		__Context_init_unchained();
		__ERC165_init_unchained();
		__AccessControl_init_unchained();
		__AssetManagement_init_unchained();
	}

	function __AssetManagement_init_unchained() internal onlyInitializing {
		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
	}

	function depositERC20(
		address _bucket,
		address _spender,
		address _currency,
		uint256 _quantity
	) external onlyRole(TRANSFERABLE_ERC20_ROLE) {
		// must be ERC20 (is not ERC721)
		require(
			_currency != address(0) && !_currency.supportsInterface(type(IERC721Upgradeable).interfaceId),
			"AssetManagement: ERC20 token is not supported"
		);

		if (_quantity == 0) return; // ignore

		_erc20[_bucket][_currency] += _quantity;

		_currency.functionCall(
			abi.encodeWithSignature("transferFrom(address,address,uint256)", _spender, address(this), _quantity)
		);

		emit DepositERC20(_bucket, _spender, _currency, _quantity);
	}

	function withdrawERC20(address _bucket, address _receiver, address _currency, uint256 _quantity) external {
		require(_bucket == _msgSender(), "AssetManagement: only owner can withdraw");

		require(
			_currency != address(0) && !_currency.supportsInterface(type(IERC721Upgradeable).interfaceId),
			"AssetManagement: ERC20 token is not supported"
		);
		require(_erc20[_bucket][_currency] >= _quantity, "AssetManagement: ERC20 token balance is not enough");

		if (_quantity == 0) return; // ignore

		_erc20[_bucket][_currency] -= _quantity;

		_currency.functionCall(abi.encodeWithSignature("transfer(address,uint256)", _receiver, _quantity));

		emit WithdrawERC20(_bucket, _receiver, _currency, _quantity);
	}

	function balanceERC20Of(address _bucket, address _currency) external view returns (uint256) {
		return _erc20[_bucket][_currency];
	}

	function depositERC721(
		address _bucket,
		address _owner,
		address _collection,
		uint256 _tokenId
	) external override onlyRole(TRANSFERABLE_ERC721_ROLE) {
		require(
			_collection.supportsInterface(type(IERC721Upgradeable).interfaceId),
			"AssetManagement: ERC721 token is not supported"
		);

		_erc721[_collection][_tokenId] = _bucket;
		IERC721Upgradeable(_collection).transferFrom(_owner, address(this), _tokenId);

		emit DepositERC721(_bucket, _owner, _collection, _tokenId);
	}

	function withdrawERC721(
		address _bucket,
		address _receiver,
		address _collection,
		uint256 _tokenId
	) external override {
		require(
			_collection.supportsInterface(type(IERC721Upgradeable).interfaceId),
			"AssetManagement: ERC721 token is not supported"
		);
		require(_bucket == _msgSender(), "AssetManagement: only owner can withdraw");
		require(_erc721[_collection][_tokenId] == _bucket, "AssetManagement: ERC721 token is not avaiable");

		_erc721[_collection][_tokenId] = address(0); // reset
		IERC721Upgradeable(_collection).transferFrom(address(this), _receiver, _tokenId);

		emit WithdrawERC721(_bucket, _receiver, _collection, _tokenId);
	}

	function ownerERC721Of(address _collection, uint256 _tokenId) external view returns (address) {
		return _erc721[_collection][_tokenId];
	}

	function proxyTransferERC20(
		address _spender,
		address _receiver,
		address _currency,
		uint256 _quantity
	) external override onlyRole(TRANSFERABLE_ERC20_ROLE) {
		require(
			_currency != address(0) && !_currency.supportsInterface(type(IERC721Upgradeable).interfaceId),
			"AssetManagement: ERC20 token is not supported"
		);

		IERC20(_currency).transferFrom(_spender, _receiver, _quantity);
	}

	function proxyTransferERC721(
		address _spender,
		address _receiver,
		address _collection,
		uint256 _tokenId
	) external override onlyRole(TRANSFERABLE_ERC721_ROLE) {
		require(
			_collection.supportsInterface(type(IERC721Upgradeable).interfaceId),
			"AssetManagement: ERC721 token is not supported"
		);

		IERC721Upgradeable(_collection).transferFrom(_spender, _receiver, _tokenId);
	}

	function supportsInterface(
		bytes4 interfaceId
	) public view override(AccessControlUpgradeable, IERC165Upgradeable) returns (bool) {
		return
			super.supportsInterface(interfaceId) ||
			type(IERC20AssetManagement).interfaceId == interfaceId ||
			type(IERC721AssetManagement).interfaceId == interfaceId ||
			type(IProxyTransferERC20).interfaceId == interfaceId ||
			type(IProxyTransferERC721).interfaceId == interfaceId;
	}
}
