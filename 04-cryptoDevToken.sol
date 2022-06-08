// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

// imports
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract CryptoDevToken is ERC20 {
    
    // properties
    uint256 private _totalSupply;

    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // event - já implementado no contrato importado
    // event Transfer(address from, address to, uint256 value);
    // event Approval(address Owner, address spender, uint256 value);

    // constructor
    constructor(uint256 initialSupply) ERC20("Crypto Dev Token", "CRYD") {
        _mint(msg.sender, initialSupply);
    }

    // public functions

    function decimals() public override pure returns(uint8) {
        return 6;
    }

    function totalSupply() public override view returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public override view returns(uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public override returns(bool) {
        _transfer(msg.sender, to, amount);

        return true;
    }

    function allowance(address owner, address spender) public override view returns(uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns(bool) {
        _approve(msg.sender, spender, amount);

        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public override returns(bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "ERC20: Insufficient Allowance to Transfer");
        
        _transfer(from, to, amount);
        _approve(from, msg.sender, currentAllowance - amount);

        return true;
    }


    // auxiliary functions
    function increaseAllowance(address spender, uint256 addedValue) public override returns(bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];

        _approve(msg.sender, spender, currentAllowance += addedValue);

        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public override returns(bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];

        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");

        unchecked {
            _approve(msg.sender, spender, currentAllowance -= subtractedValue);
        }

        return true;
    }

    // internal functions
    function _transfer(address from, address to, uint256 amount) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        
        uint256 senderBalance = _balances[from];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");

        unchecked {
            _balances[from] -= amount;
        }

        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal override {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }

    function _mint(address account, uint256 amount) internal override {
        _totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(address(0), account, amount);
    }
}