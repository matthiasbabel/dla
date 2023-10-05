// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Mappings {

    mapping(string => string) private Dictionary;

    function addWord(string calldata word, string calldata translation) public {
        Dictionary[word] = translation;
    }

    function lookUpWord(string calldata word) public view returns (string memory translation) {
        return Dictionary[word];
    } 

}
