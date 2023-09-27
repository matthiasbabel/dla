// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract OffSetting {

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor() {
        totalSupply = 100;
    }

    balanceOf(address _owner) public view returns ()

    function transfer(address _to, uint256 _amount) returns (bool success) {
        require(balanceOf[])
        return true;
    }

}
