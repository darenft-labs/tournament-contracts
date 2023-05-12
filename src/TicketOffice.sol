// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

import "./interfaces/ITicketOffice.sol";
import "./interfaces/IERC20AssetManagement.sol";

import "./Ticket.sol";
import "./AssetManagementSupported.sol";


/**
 * @title IClaimable
 * @author DareNFT
 * @notice Register logic
 *
 * available tickets = totalSupply -
 */
contract TicketOffice is
	Initializable,
	ERC165Upgradeable,
	ContextUpgradeable,
	ITicketOffice,
	AssetManagementSupported,
	Ticket
{
	uint256 internal _price;
	address internal _currency;

	mapping(address => bool) internal _isRegistered;

	uint256 internal _totalProfit;

	/// @custom:oz-upgrades-unsafe-allow constructor
	constructor() {
		_disableInitializers();
	}

	function __TicketOffice_init(
		string memory name_,
		uint256 totalTickets_,
		address currency_,
		uint256 price_,
		address assetManagement_
	) internal onlyInitializing {
		__Context_init_unchained();
		__Ticket_init_unchained(name_, "TIK", totalTickets_);
		__TicketOffice_init_unchained(currency_, price_);
		__AssetManagementSupported_init(assetManagement_);
	}

	function __TicketOffice_init_unchained(address currency_, uint256 price_) internal onlyInitializing {
		_totalProfit = 0;

		_setCurrency(currency_);
		_setPrice(price_);
	}

	function currency() external view override returns (address) {
		return _currency;
	}

	function totalProfit() external view override returns (uint256) {
		return _totalProfit;
	}

	/**
	 * default as ticket
	 */
	function ticket() external view override returns (address) {
		return address(this);
	}

	/**
	 * ticket price
	 * @param _quantity How many tickets
	 */
	function priceOf(uint256 _quantity) public view override returns (uint256) {
		return _quantity * _price;
	}

	function _setCurrency(address currency_) internal {
		_currency = currency_;
		emit NewCurrency(currency_);
	}

	function _setPrice(uint256 price_) internal {
		_price = price_;
		emit UpdatePrice(price_);
	}

	/**
	 * @param _quantity How many tickets
	 */
	function buy(uint256 _quantity) public virtual override {
		// TODO: need verify to register
		address _owner = _msgSender();

		_isRegistered[_owner] = true;
		uint256 total = priceOf(_quantity);

		_totalProfit += total;
		_mint(_owner, _quantity);

		IERC20AssetManagement(assetManagement()).depositERC20(address(this), _owner, _currency, total);

		emit NewSell(_owner, _quantity, total);
	}

	function supportsInterface(
		bytes4 interfaceId
	) public view virtual override(AssetManagementSupported, ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
		return
			super.supportsInterface(interfaceId) ||
			type(ITicket).interfaceId == interfaceId ||
			type(ITicketOffice).interfaceId == interfaceId ||
			type(IAssetManagementSupported).interfaceId == interfaceId;
	}

	function cap() public view virtual override(ITicketOffice, Ticket) returns (uint256) {
		return super.cap();
	}

	function isPlayer(address _player) external view override returns (bool) {
		return _isRegistered[_player];
	}
}
