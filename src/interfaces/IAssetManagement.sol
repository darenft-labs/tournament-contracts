// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

import "./IERC20AssetManagement.sol";
import "./IERC721AssetManagement.sol";
import "./IProxyTransferERC20.sol";
import "./IProxyTransferERC721.sol";

interface IAssetManagement is
	IERC20AssetManagement,
	IERC721AssetManagement,
	IProxyTransferERC20,
	IProxyTransferERC721
{}
