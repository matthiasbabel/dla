// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OffsetToken {
// State vars
    string public name;
    string public symbol;
    uint public totalSupply;
    address public owner;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    mapping(address => bool) mintList;
    mapping(address => uint) prices;

// Constructor
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        totalSupply = 100;
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

// Functions
    function balanceOf(address _owner) public view returns(uint balance){
        return balances[_owner];
    }

    function transfer(address _to, uint _amount) public returns(bool success) {
        require(balances[msg.sender]>= _amount, "Not enough funds!");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        return true;
    }

    function burn(uint _amount) public {
        require(balanceOf(msg.sender) >=  _amount);
        totalSupply -= _amount;        
        transfer(address(0),_amount);
    }

    function addAllowBurn(address _burner, uint _amount) public returns(uint _total) {
        require(balances[msg.sender]>= _amount, "Not enough funds!");
        allowances[msg.sender][_burner] += _amount;
        return allowances[msg.sender][_burner];
    }

    function burnFrom(address _from, uint _amount) public returns(uint remaining){
        require(allowances[_from][msg.sender]>= _amount && balances[_from]>=_amount,"Not enough funds!");
        allowances[_from][msg.sender] -= _amount;
        totalSupply -= _amount;
        balances[_from] -= _amount;
        return allowances[_from][msg.sender];
    }

    function allowMinting(address _minter) public {
        require(msg.sender == owner, "No permission!");
        mintList[_minter] = true;
    }

    function mint(uint _amount) public {
        require(mintList[msg.sender]==true, "No permission!");
        totalSupply += _amount;
        balances[msg.sender] += _amount;
    }

    function setPrice(uint _price) public {
        prices[msg.sender] = _price;
    }

    function buy(address payable _from, uint _amount) public payable returns (bool success) {
        require(balances[_from]>=_amount, "Insufficient seller funds!");        
        uint price = prices[_from];
        uint total = _amount * price;
        require(msg.value >= total, "Insufficient buyer funds!");

        // If buyer has enough funds to pay the total price
        if (msg.value >= total) {
            uint change = msg.value - total;

            // Check-Effects: Update state before interaction (sending ether)
            balances[_from] -= _amount;
            balances[msg.sender] += _amount;

            // Interaction: Transfer Ether to seller and handle change
            (bool sentToSeller, ) = _from.call{value: total}("");
            require(sentToSeller, "Payment to seller failed");

            if (change > 0) {
                (bool sentChange, ) = msg.sender.call{value: change}("");
                require(sentChange, "Change transfer failed");
            }

            return true;
        } 
    }
}