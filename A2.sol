// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OffsetToken {
// State vars
    string name;
    string symbol;
    uint public totalSupply;
    address owner;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    mapping(address => bool) mintList;

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
}