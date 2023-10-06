// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract DataStructures {

    string[] private shelf;

    function putInShelf(string calldata item) public {
        shelf.push(item);
    }

    function displayShelf() public view returns (string[] memory) {
        return shelf;
    }

    function getFromShelf(uint index) public view returns (string memory) {
        return shelf[index];
    }
}
