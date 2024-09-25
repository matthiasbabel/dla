// SPDX-License_Identifier: MIT
pragma solidity ^0.8.6;

contract HelloWorld {

    string text;

    constructor() {
        text = "HelloWorld";
    }

    function getText() public view returns(string memory) {
        return text;
    }

    function setText(string memory _newText) public {
        text = _newText;
    }
}
