// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Bank {

    // properties
    address private owner;
    mapping(address => uint) public addressToBalance; // balanceByAddress // balances

    // modifiers
    modifier isOwner() {
        require(msg.sender == owner , "Sender is not owner");
        _;
    }

    // events
    event BalanceIncreased(address target, uint256 balance);
    event OwnerChanged(address oldOwner, address newOwner);

    // constructor
    constructor() {
        owner = msg.sender;
    }

    // public functions
    function addBalance(address to, uint value) public isOwner {
        // adicionar um saldo para uma carteira
        addressToBalance[address(to)] += value;
        // emitir um evento
        emit BalanceIncreased(to, value);
    }

    function changeOwner(address newOwnerContract) public isOwner {
        emit OwnerChanged(owner, newOwnerContract);
        owner = newOwnerContract;
    }
}