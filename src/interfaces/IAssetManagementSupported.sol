// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

interface IAssetManagementSupported is IERC165Upgradeable {
	function assetManagement() external view returns (address);
}
