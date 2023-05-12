// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

interface IProxyTransferERC721 is IERC165Upgradeable {
	function proxyTransferERC721(address _spender, address _receiver, address _collection, uint256 _tokenId) external;
}
