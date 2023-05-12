// // SPDX-License-Identifier: SEE LICENSE IN LICENSE
// pragma solidity ^0.8.0;

// import { Context } from "@openzeppelin/contracts/utils/Context.sol";
// import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
// import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
// import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
// import "@openzeppelin/contracts/utils/Clones.sol";
// import {} from "@openzeppelin/contracts/access/AccessControl.sol";


// import { IFactory } from "./interfaces/IFactory.sol";


// contract Factory is IFactory, EIP712, Context, Ownable, AccessControl {

// 	using SignatureChecker for address;

// 	bytes32 public constant TOUR_DATA_HASH_STRUCT = keccak256("TourData(address strategy,string name,address deployer,int64 startDate,int64 endDate,bytes params,uint256 nonce)");
// 	bytes32 public constant TOURNAMENT_DEPLOYER_ROLE = keccak256("TOURNAMENT_DEPLOYER_ROLE");

// 	address internal _assetManagement;

// 	mapping(bytes32 => address) internal _tours;
// 	mapping(address => mapping(uint256 => bool)) internal _noneExpired;

// 	mapping(address => uint256) internal _nonces;


// 	constructor() EIP712("TournamentFactory", "0.0.1") {
// 		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
// 		_setupRole(TOURNAMENT_DEPLOYER_ROLE, _msgSender());
// 	}

// 	function nonceOf(address deployer) external view returns (uint256) {
// 		return _nonces[deployer];
// 	}

// 	function assetManagement() external override view returns (address) {
// 		return _assetManagement;
// 	}


// 	function setAssetManagement(address _assetManagement) external override onlyOwner {
// 		_assetManagement = _assetManagement;
// 	}

// 	function __Factory_init_unchained(
// 		address assetManagement_,
// 		address tournament_,
// 	) internal {
// 		require(_assetManagement.supportsInterface(type(IAssetManagement).interfaceId), "Factory: invalid assetManagement");

// 		_assetManagement = assetManagement_;
// 	}

// 	function createTournament(Tourdata memory _data, bytes memory _signature) external override onlyRole(TOURNAMENT_DEPLOYER_ROLE) {
// 		require(! _noneExpired[_data.deployer], "Factory: nonce expired");
// 		require(_data.deployer.isValidSignatureNow(hashTypedDataV4(_data), _signature), "Factory: invalid signature");

// 		address strategy = _data.strategy;
// 		bytes32 salt = keccak256(abi.encode(_data.deployer, data.nonce));
// 		address newTournament = Clones.cloneDeterministic(strategy, salt);

// 		// Address.functionCall(newTournament, abi.encodeWithSelector(ITournament.initialize));

// 		// setup
// 		emit TournamentCreated(_data.deployer, _data.nonce, newTournament, _data);
// 	}

//   function hashTypedDataV4(Tourdata memory _data) internal view virtual returns (bytes32) {
//     return _hashTypedDataV4(keccak256(abi.encode(
// 			TOUR_DATA_HASH_STRUCT,
// 			_data.strategy,
// 			keccak256(_data.name),
// 			_data.deployer,
// 			_data.startDate,
// 			_data.endDate,
// 			keccak256(_data.params),
// 			_data.nonce
// 		)));
//   }

// 	function supportsInterface(bytes4 interfaceId) external override(Register, Claimable) view returns (bool) {
// 		return ERC165.supportsInterface(interfaceId) || type(IFactory).interfaceId == interfaceId;
// 	}
// }
