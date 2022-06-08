// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Storage {

    // properties
    int private numeroDev;

    // constructor
    constructor() {}

    // public functions
    
    function get() public view returns (int) {
        return numeroDev;
    }
    
    function store(int num) public {
        numeroDev = num;
    }
    


}