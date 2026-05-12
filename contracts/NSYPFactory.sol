// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @title No-Show Yield Protocol
/// @notice Converts service industry no-show rates into DeFi yield

contract NSYPFactory is Ownable, ReentrancyGuard {
    address public immutable nsypUSDC;
    mapping(address => BusinessVault) public businesses;
    uint256 public constant SPREAD_BPS = 3000; // 30% spread

    struct BusinessConfig {
        uint256 noShowRate;    // in bps (1500 = 15%)
        uint256 totalShows;
        uint256 totalNoShows;
        bool active;
    }

    event BusinessRegistered(address indexed business, uint256 noShowRate);
    event DepositCaptured(address indexed business, address indexed client, uint256 amount);
    event InsuranceClaimed(address indexed business, uint256 amount);

    constructor(address _nsypUSDC) Ownable(msg.sender) {
        nsypUSDC = _nsypUSDC;
    }

    function registerBusiness(uint256 initialRate) external {
        businesses[msg.sender] = BusinessVault({
            noShowRate: initialRate,
            totalShows: 0,
            totalNoShows: 0,
            active: true
        });
        emit BusinessRegistered(msg.sender, initialRate);
    }

    function calculateDeposit(uint256 servicePrice) public view returns (uint256) {
        return servicePrice + (servicePrice * SPREAD_BPS / 10000);
    }

    function calculatePremium(uint256 servicePrice, uint256 rateBps) public pure returns (uint256) {
        uint256 expectedLoss = servicePrice * rateBps / 10000;
        return expectedLoss + (expectedLoss * SPREAD_BPS / 10000);
    }
}
