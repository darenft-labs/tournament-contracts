// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import "./interfaces/ITicket.sol";

contract Ticket is Initializable, ITicket, ERC20Upgradeable {
	uint256 internal _cap;

	/// @custom:oz-upgrades-unsafe-allow constructor
	constructor() {
		_disableInitializers();
	}

	function __Ticket_init(string memory name_, string memory symbol_, uint256 cap_) internal onlyInitializing {
		__Ticket_init_unchained(name_, symbol_, cap_);
	}

	function __Ticket_init_unchained(
		string memory name_,
		string memory symbol_,
		uint256 cap_
	) internal onlyInitializing {
		_cap = cap_;
		__ERC20_init_unchained(name_, symbol_);
	}

	function decimals() public view virtual override returns (uint8) {
		return 0;
	}

	/**
	 * @dev Returns the cap on the token's total supply.
	 */
	function cap() public view virtual override returns (uint256) {
		return _cap;
	}

	function _mint(address account, uint256 amount) internal virtual override {
		// unlimited cap
		require(cap() == 0 ? true : ERC20Upgradeable.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
		super._mint(account, amount);
	}
}
