// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

interface IERC20AssetManagement is IERC165Upgradeable {
	event DepositERC20(address indexed bucket, address indexed spender, address indexed currency, uint256 quantity);
	event WithdrawERC20(address indexed bucket, address indexed receiver, address indexed currency, uint256 quantity);

	function depositERC20(address _bucket, address _spender, address _currency, uint256 _quantity) external;

	function withdrawERC20(address _bucket, address _receiver, address _currency, uint256 _quantity) external;

	function balanceERC20Of(address _bucket, address _currency) external view returns (uint256);
}
