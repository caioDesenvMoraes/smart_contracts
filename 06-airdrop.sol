// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./03-token.sol";

contract Airdrop  {

    // Using Libs

    // Structs

    // Enum
    enum Status { ACTIVE, PAUSED, CANCELLED } // mesmo que uint8


    // Properties
    address private owner;
    address public tokenAddress;
    uint256 private maxSubscribers = 10;
    address[] private subscribers;
    Status contractState; 

    // Modifiers
    modifier isOwner() {
        require(msg.sender == owner , "Sender is not owner!");
        _;
    }

    // Events
    event NewSubscriber(address beneficiary, uint amount);
    event Kill(address owner);

    // Constructor
    constructor(address token) {
        owner = msg.sender;
        tokenAddress = token;
        contractState = Status.PAUSED;
    }


    // Public Functions
    function subscribe() public returns(bool) {
        require(subscribers.length < 10, "maximum number of addresses");
        require(hasSubscribed(msg.sender));

        subscribers.push(msg.sender);

        if(subscribers.length == maxSubscribers) execute();

        return true;
    }

    function state() public view returns(Status) {
        return contractState;
    }

    function getSubscribes() public view returns(address[] memory) {
        return subscribers;
    }

    function getLengthSubscribes() public view returns(uint256) {
        return subscribers.length;
    }

    // Private Functions
        function execute() private returns(bool) {

        uint256 balance = CryptoToken(tokenAddress).balanceOf(address(this));
        uint256 amountToTransfer = balance / subscribers.length;
        for (uint i = 0; i < subscribers.length; i++) {
            require(subscribers[i] != address(0));
            require(CryptoToken(tokenAddress).transfer(subscribers[i], amountToTransfer));

            emit NewSubscriber(subscribers[i], amountToTransfer);
        }

        return true;
    }
    
    function hasSubscribed(address subscriber) private view returns(bool) {
        for(uint256 i = 0; i < subscribers.length; i++) {
            require(subscribers[i] != subscriber, "address already registered");
        }

        return true;
    }

    // Kill
    function kill() public isOwner {
        selfdestruct(payable(owner));

        emit Kill(owner);
    }
    
    
}