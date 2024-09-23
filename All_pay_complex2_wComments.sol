// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OffsetToken {
    // State variables
    string public name;
    string public symbol;
    uint public totalSupply;
    address public owner;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    mapping(address => bool) mintList;
    mapping(address => uint) prices;

    // Constructor to set token name, symbol, and initial supply
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        totalSupply = 100; // Initial total supply
        owner = msg.sender; // Contract deployer is the owner
        balances[owner] = totalSupply; // Assign all tokens to owner initially
    }

    // Function to check balance of a given account
    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }

    // Function to transfer tokens from sender to a specified address
    function transfer(address _to, uint _amount) public returns (bool success) {
        require(balances[msg.sender] >= _amount, "Not enough funds!");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        return true;
    }

    // Function to burn (destroy) tokens from the caller's balance
    function burn(uint _amount) public {
        require(balanceOf(msg.sender) >= _amount, "Insufficient balance to burn");
        totalSupply -= _amount;
        transfer(address(0), _amount); // Burn by transferring to the zero address
    }

    // Allow another account to burn tokens from the caller's balance
    function addAllowBurn(address _burner, uint _amount) public returns (uint _total) {
        require(balances[msg.sender] >= _amount, "Not enough funds!");
        allowances[msg.sender][_burner] += _amount;
        return allowances[msg.sender][_burner];
    }

    // Function to burn tokens from another account's balance, if approved
    function burnFrom(address _from, uint _amount) public returns (uint remaining) {
        require(allowances[_from][msg.sender] >= _amount, "Allowance exceeded");
        require(balances[_from] >= _amount, "Not enough funds!");
        allowances[_from][msg.sender] -= _amount;
        totalSupply -= _amount;
        balances[_from] -= _amount;
        return allowances[_from][msg.sender];
    }

    // Only the owner can allow specific addresses to mint new tokens
    function allowMinting(address _minter) public {
        require(msg.sender == owner, "No permission! Only owner can allow minting");
        mintList[_minter] = true;
    }

    // Function to mint (create) new tokens, only if minting is allowed
    function mint(uint _amount) public {
        require(mintList[msg.sender] == true, "No permission to mint tokens");
        totalSupply += _amount;
        balances[msg.sender] += _amount;
    }

    // Set a price for the tokens held by the caller
    function setPrice(uint _price) public {
        prices[msg.sender] = _price;
    }

    // Buy tokens from another address
    function buy(address payable _from, uint _amount, bool frac) public payable returns (bool success) {
        uint price = prices[_from];
        uint total = _amount * price;

        // Full purchase logic
        if (!frac) {
            require(msg.value >= total, "Not enough funds sent!");
            require(balances[_from] >= _amount, "Seller has not enough tokens!");
            
            _executeTransfer(_from, msg.sender, _amount, total);

            return true;
        }

        // Fractional purchase logic
        uint maxAmount = msg.value / price;
        uint finalAmount = (_amount <= maxAmount) ? _amount : maxAmount;
        
        // Adjust amount to what the seller can provide
        if (balances[_from] < finalAmount) {
            finalAmount = balances[_from];  // Seller can only sell what they have
        }
        
        require(finalAmount > 0, "Seller has no tokens to sell");

        uint pay = finalAmount * price;
        _executeTransfer(_from, msg.sender, finalAmount, pay);

        return true;
    }

    function _executeTransfer(address payable seller, address buyer, uint amount, uint pay) internal {
        uint change = msg.value - pay;

        balances[seller] -= amount;
        balances[buyer] += amount;

        (bool sentToSeller, ) = seller.call{value: pay}("");
        require(sentToSeller, "Payment to seller failed");

        if (change > 0) {
            (bool sentChange, ) = buyer.call{value: change}("");
            require(sentChange, "Change transfer failed");
        }
    }
}

