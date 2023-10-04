// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract OffSetting {

    uint public totalSupply;
    mapping(address => uint256) private balances;

    constructor() {
        totalSupply = 100;
        balances[msg.sender] = totalSupply;
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
}
