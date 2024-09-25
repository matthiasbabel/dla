// SPDX-License_Identifier: MIT
pragma solidity ^0.8.6;

contract HelloWorld {

    string text;

    constructor() {
        text = "HelloWorld";
    }

    function getText() returns(string memory) {
        return text;
    }

    function setText(string memory _newText) {
        text = _newText;
    }
}
