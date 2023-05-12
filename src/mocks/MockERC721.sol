// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";

contract MockERC721 is ERC721PresetMinterPauserAutoId {
	constructor(string memory _name, string memory _symbol) ERC721PresetMinterPauserAutoId(_name, _symbol, "") {
		_setupRole(MINTER_ROLE, _msgSender());
	}
}
