// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {

	constructor(string memory _name, string memory _symbol)
		ERC20(_name, _symbol) {

		_mint(msg.sender, 10 ** 9 * 10 ** 18);
	}
}
