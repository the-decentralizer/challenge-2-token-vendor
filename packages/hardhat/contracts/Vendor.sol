pragma solidity ^0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";
import "hardhat/console.sol";

contract Vendor is Ownable {
    //event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // signal successful token purchase
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    event SellTokens(
        address seller,
        uint256 amountOfEth,
        uint256 amountOfTokens
    );

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        console.log(msg.value);
        uint256 purchaseAmount = tokensPerEth * msg.value;
        require(purchaseAmount > 0, "Please buy a positive amount of tokens");
        yourToken.transfer(msg.sender, purchaseAmount);
        emit BuyTokens(msg.sender, msg.value, purchaseAmount);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    // ToDo: create a sellTokens(uint256 _amount) function:

    function sellTokens(uint256 _amount) public {
        require(
            _amount >= 0,
            "You need to sell some tokens. If you want to sell negative just buy some :D"
        );
        uint256 allowed = yourToken.allowance(msg.sender, address(this));
        require(allowed >= _amount, "Increase approval please");
        uint256 saleInEth = _amount / tokensPerEth;
        require(
            address(this).balance >= saleInEth,
            "Contract doesn't have the funds rn"
        );
        yourToken.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(saleInEth);
        emit SellTokens(msg.sender, saleInEth, _amount);
        // yourToken.transfer()
    }
}
