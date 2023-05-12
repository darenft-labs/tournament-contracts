// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

/**
 * @title IRegistrable
 * @author DareNFT
 * @notice User can register & receive ERC20 Token as total of ticket
 */
interface ITicketOffice is IERC165Upgradeable {
	event NewSell(address indexed _account, uint256 _quantity, uint256 _amount);
	event NewCurrency(address indexed _currency);
	event UpdatePrice(uint256 _price);

	function ticket() external view returns (address);

	function currency() external view returns (address);

	/**
	 * total ticket
	 */
	function cap() external view returns (uint256);

	function totalProfit() external view returns (uint256);

	// total sold
	// function totalSupply() external view returns (uint256);

	/**
	 * @param _quantity How many tickets
	 */
	function buy(uint256 _quantity) external;

	function isPlayer(address _player) external view returns (bool);

	function priceOf(uint256 _quantity) external view returns (uint256);
}
