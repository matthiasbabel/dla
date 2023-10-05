// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract OffSetting {

    uint public totalSupply;
    address owner;
    mapping(address => bool) public allowancesMint;
    mapping(address => uint256) public prices;
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) public allowancesBurn;

    constructor() {
        totalSupply = 100;
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    } 

    function transfer(address _to, uint256 _amount) public returns (bool success) {
        
        require(balanceOf(msg.sender) >= _amount, "Not enough funds");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        
        return true;
    }

    // Task3 - Trading of offsets
    // Set Price
    function setPrice(uint256 _price) public {
        prices[msg.sender] = _price
    }

    // Task3
    // Buy offsets. if price = 0: Buying not possible
    function buy(address payable _from) public payable {
        require(prices[_from] != 0; "Not possible");
        uint256 amount = msg.value \ price;
        require(balances[_from] <= amount, "Not enough offsets");
        
        balances[msg.sender] += _amount;
        balances[_from] -= _amount;
        //ggf. ersetzen mit "Call" https://solidity-by-example.org/sending-ether/
        _from.send(msg.value);
    }

    // Task2 
    // Allow selected parties to mint offsets (only by contract owner)
    function allowMinting(address _minter) public {
        require(msg.sender == owner, "No permission");
        allowancesMint[_minter] = true;
    }

    // Task2
    // Implement Minting for authorized addresses
    function mint(uint256 _amount) public {
        require(allowancesMint[msg.sender], "No allowance for minting");
        balances[msg.sender] += _amount;
    }

    function burn(uint256 _amount) public {
        balances[msg.sender] -= _amount;
    }

    // Task 1
    // Give some third party the allowance to burn your offset 
    function addAllowBurn(address _burner, uint256 _amount) public returns (uint256) {
        allowancesBurn[msg.sender][_burner] = _amount;
        return allowancesBurn[msg.sender][_burner];
    }

    // Task 1
    // Burn Offset of someone else
    function burnFrom(address _from, uint256 _amount) public returns (uint256) {
        require(allowancesBurn[_from][msg.sender] >= _amount, "No allowance");
        allowancesBurn[_from][msg.sender] -= _amount;
        return allowancesBurn[_from][msg.sender];
    }

    // Task 4
    // Add a Struct, which logs all minting events. Amount, Minter, Description
    // TODO: Implement
}
