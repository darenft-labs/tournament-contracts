// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import {ITournament} from "./interfaces/ITournament.sol";

import "./AssetManagementSupported.sol";
import "./helpers/Time.sol";
import "./Reward.sol";
import "./TicketOffice.sol";
import "./TournamentRule.sol";

/**
 * @title Tournament
 * @author DareNFT
 * @notice Create a tournament, each ticket as NFT
 *
 * Tournament V1
 */
contract Tournament is
	Initializable,
	IAssetManagementSupported,
	Ownable2StepUpgradeable,
	Ticket,
	TicketOffice,
	Time,
	TournamentRule,
	ITournament
{
	address internal _reward;

	/// @custom:oz-upgrades-unsafe-allow constructor
	constructor() {
		_disableInitializers();
	}

	function initialize(
		address assetManagement_,
		address owner_,
		string memory name_,
		int64 startDate_,
		int64 endDate_,
		// entrance settings
		uint256 totalTickets_,
		uint256 pricePerTicket_,
		address currency_,
		uint256 nftPerTicket_,
		uint256 initialReward_,
		uint256 percentRewardFromTicketOffice_,
		string memory metadataRuleURI_
	) public initializer {
		__Tournament_init(
			assetManagement_,
			owner_,
			name_,
			startDate_,
			endDate_,
			// entrance settings
			totalTickets_,
			pricePerTicket_,
			currency_,
			nftPerTicket_,
			initialReward_,
			percentRewardFromTicketOffice_,
			metadataRuleURI_
		);
	}

	function __Tournament_init(
		address assetManagement_,
		address owner_,
		string memory name_,
		int64 startDate_,
		int64 endDate_,
		// entrance settings
		uint256 totalTickets_,
		uint256 pricePerTicket_,
		address currency_,
		uint256 nftPerTicket_,
		uint256 initialReward_,
		uint256 percentRewardFromTicketOffice_,
		string memory metadataRuleURI_
	) internal onlyInitializing {
		__Context_init_unchained();
		__ERC165_init_unchained();
		__AssetManagementSupported_init_unchained(assetManagement_);

		// config sale logic
		__Ticket_init_unchained(name_, "TIK", totalTickets_);
		__TicketOffice_init_unchained(currency_, pricePerTicket_);

		__Tournament_init_unchained(owner_, startDate_, endDate_);
		__TournamentRule_init_unchained(
			address(this),
			nftPerTicket_,
			initialReward_,
			percentRewardFromTicketOffice_,
			metadataRuleURI_
		);
	}

	function __Tournament_init_unchained(address owner_, int64 startDate_, int64 endDate_) internal onlyInitializing {
		__Time_init_unchained(startDate_, endDate_);
		_transferOwnership(owner_);
	}

	function setReward(address reward_) public onlyOwner {
		_reward = reward_;
	}

	function cap() public view override(Ticket, TicketOffice) returns (uint256) {
		return Ticket.cap();
	}

	function owner() public view override(ITournament, OwnableUpgradeable) returns (address) {
		return OwnableUpgradeable.owner();
	}

	// can not buy after tournament is closed
	function buy(uint256 quantity_) public virtual override isCurrentBeforeClosingTime {
		super.buy(quantity_);
	}

	function reward() public view override returns (address) {
		return _reward;
	}

	function supportsInterface(
		bytes4 interfaceId
	) public view virtual override(IERC165Upgradeable, TicketOffice, Time, TournamentRule) returns (bool) {
		return
			ERC165Upgradeable.supportsInterface(interfaceId) ||
			TicketOffice.supportsInterface(interfaceId) ||
			Time.supportsInterface(interfaceId) ||
			TournamentRule.supportsInterface(interfaceId);
	}
}
