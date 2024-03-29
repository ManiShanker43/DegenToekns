// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    mapping(address => bool) public hasPurchased;

    struct Item {
        string name;
        uint256 price;
    }

    Item[] public items;

    constructor(address initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner) {
        items.push(Item("Product A", 100));
        items.push(Item("Product B", 200));
        items.push(Item("Product C", 300));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function decimals() public pure override returns (uint8) {
        return 18; // Update the number of decimals to match your token's configuration
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(_msgSender()) >= amount, "Insufficient balance");

        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function purchase(uint256 itemId) public {
        require(itemId < items.length, "Invalid item ID");
        require(!hasPurchased[msg.sender], "Already purchased");

        Item memory item = items[itemId];
        uint256 price = item.price;

        require(balanceOf(_msgSender()) >= price, "Insufficient balance");

        _burn(_msgSender(), price);
        hasPurchased[msg.sender] = true;
    }

    function burn(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(_msgSender()) >= amount, "Insufficient balance");

        _burn(_msgSender(), amount);
    }

    function balanceOf(address account) public view override returns (uint256) {
        return super.balanceOf(account);
    }
}
