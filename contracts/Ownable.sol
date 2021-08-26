// SPDX-License-Identifier: RIZ

pragma solidity ^0.8.0;

contract Ownable{
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(isOwner(), "You are not the owner");
        _;
    }

    function isOwner() public view returns(bool){
        return owner == msg.sender;
    }
}