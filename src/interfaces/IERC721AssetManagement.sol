// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

interface IERC721AssetManagement is IERC165Upgradeable {
	event DepositERC721(address indexed bucket, address indexed sender, address indexed collection, uint256 tokenId);
	event WithdrawERC721(address indexed bucket, address indexed receiver, address indexed collection, uint256 tokenId);

	function depositERC721(address _bucket, address _receiver, address _collection, uint256 _tokenId) external;

	function withdrawERC721(address _bucket, address _receiver, address _collection, uint256 _tokenId) external;

	function ownerERC721Of(address _collection, uint256 _tokenId) external view returns (address);
}
