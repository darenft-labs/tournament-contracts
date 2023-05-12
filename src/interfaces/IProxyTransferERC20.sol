// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

interface IProxyTransferERC20 is IERC165Upgradeable {
	function proxyTransferERC20(address _spender, address _receiver, address _currency, uint256 _quantity) external;
}
