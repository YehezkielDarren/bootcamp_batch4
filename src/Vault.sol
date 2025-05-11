// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault is ERC20{

    address public usdc;

    constructor(address _usdc) ERC20("Vault", "VAULT") {
        usdc = _usdc;
    }
    
    function deposit(uint256 amount) public {
        // shares = deposit amuont / total asset * total shares
        uint256 totalAsset = IERC20(usdc).balanceOf(address(this));
        uint256 totalShares = totalSupply();

        // logic to calculate shares
        uint256 shares=0;
        if (totalShares == 0) {
            shares = amount;
        } else {
            shares = (amount * totalShares) / totalAsset;
        }
        // mint shares to user
        _mint(msg.sender, shares);
        IERC20(usdc).transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 shares) public {
        // amount = shares * total asset / total shares
        uint256 totalAsset = IERC20(usdc).balanceOf(address(this));
        uint256 totalShares = totalSupply();

        uint256 amount = (shares * totalAsset) / totalShares;

        // burn shares from user
        _burn(msg.sender, shares); 

        // transfer USDC to user
        IERC20(usdc).transfer(msg.sender, amount);
    }

    function distributeYield(uint256 amount) public {
        IERC20(usdc).transferFrom(msg.sender, address(this), amount);
    }

}
