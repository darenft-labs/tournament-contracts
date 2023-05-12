// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "./interfaces/IAssetManagementSupported.sol";

contract AssetManagementSupported is Initializable, IAssetManagementSupported, ERC165Upgradeable {
	address internal _assetManagement;


	/// @custom:oz-upgrades-unsafe-allow constructor
	constructor() {
		_disableInitializers();
	}

	function __AssetManagementSupported_init(address assetManagement_) internal onlyInitializing {
		__ERC165_init_unchained();
		__AssetManagementSupported_init_unchained(assetManagement_);
	}

	function __AssetManagementSupported_init_unchained(address assetManagement_) internal onlyInitializing {
		_assetManagement = assetManagement_;
	}

	function assetManagement() public view returns (address) {
		return _assetManagement;
	}

	function _setAssetManagement(address _newAssetManagement) internal {
		_assetManagement = _newAssetManagement;
	}

	function supportsInterface(
		bytes4 interfaceId
	) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
		return super.supportsInterface(interfaceId) || interfaceId == type(IAssetManagementSupported).interfaceId;
	}
}
