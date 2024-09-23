// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OffsetToken {
// State vars
    string name;
    string symbol;
    uint public totalSupply;
    address owner;

    mapping(address => uint) balances;

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

    function transfer(address _to, uint _value) public returns(bool success) {
        require(balanceOf(tx.origin) >=  _value);

        balances[tx.origin] -= _value;
        balances[_to] += _value;

        return true;
    }

    function burn(uint _value) public {
        require(balanceOf(tx.origin) >=  _value);
        totalSupply -= _value;        
        transfer(address(0),_value);
    }
}