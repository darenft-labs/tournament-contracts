// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../TicketOffice.sol";

contract MockTicketOffice is TicketOffice {
	/// @custom:oz-upgrades-unsafe-allow constructor
	constructor() TicketOffice() {}

	function initialize(
		string memory name_,
		uint256 totalTickets_,
		address currency_,
		uint256 price_,
		address assetManagement_
	) public initializer {
		__TicketOffice_init(name_, totalTickets_, currency_, price_, assetManagement_);
	}
}
