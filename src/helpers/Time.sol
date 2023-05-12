// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";

import "./ITime.sol";

contract Time is Initializable, ITime, ERC165Upgradeable {
	int64 private _openningTime;
	int64 private _closingTime;

	modifier isBeforeTime(int64 _time) {
		require(_time <= _openningTime, "Time is before openning time");
		_;
	}

	modifier isAfterTime(int64 _time) {
		require(_time >= _closingTime, "Time is after closing time");
		_;
	}

	modifier isInTime(int64 _time) {
		require(_time >= _openningTime && _time <= _closingTime, "Time is not in time");
		_;
	}

	modifier isBeforeClosingTime(int64 _time) {
		require(_time <= _closingTime, "Time is before closing time");
		_;
	}

	modifier isCurrentBeforeTime() {
		int64 currentTime = int64(uint64(block.timestamp));
		require(currentTime <= _openningTime, "Time is before openning time");
		_;
	}

	modifier isCurrentAfterTime() {
		int64 currentTime = int64(uint64(block.timestamp));
		require(currentTime >= _closingTime, "Time is after closing time");
		_;
	}

	modifier isCurrentInTime() {
		int64 currentTime = int64(uint64(block.timestamp));
		require(currentTime >= _openningTime && currentTime <= _closingTime, "Time is not in time");
		_;
	}

	modifier isCurrentBeforeClosingTime() {
		int64 currentTime = int64(uint64(block.timestamp));
		require(currentTime <= _closingTime, "Time is before closing time");
		_;
	}

	function __Time_init_unchained(int64 openningTime_, int64 closingTime_) internal onlyInitializing {
		_setupTime(openningTime_, closingTime_);
	}

	function _setupTime(int64 openningTime_, int64 closingTime_) internal {
		_openningTime = openningTime_;
		_closingTime = closingTime_;
	}

	function openningTime() public view override returns (int64) {
		return _openningTime;
	}

	function closingTime() public view override returns (int64) {
		return _closingTime;
	}

	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
		return super.supportsInterface(interfaceId) || interfaceId == type(ITime).interfaceId;
	}
}
