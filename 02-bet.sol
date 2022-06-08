// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Bet {
    // structs
    struct Player {
        uint256 amountBet; // valor apostado
        uint256 numberSelected; // numero selecionado
    }

    // properties
    address public owner; // dono do contrato
    address[] public players; // apostadores
    uint256 public totalBet; // total apostado
    uint256 public minBet; // aposta minima
    uint256 public maxBet; // aposta maxima
    uint256 public maxAmountBet = 2; // valor maximo apostado

    mapping(address => Player) addressToPlayer;

    // enum - active, paused, cancelled

    // modifiers
    modifier isOwner() {
        require(msg.sender == owner, "Sender is not owner!");
        _;
    }

    // events

    // constructor
    constructor(uint256 minBetValue) {
        owner = msg.sender;
        if(minBetValue != 0) minBet = minBetValue;
    }

    // public functions
    function bet(uint256 numberSelected) public payable {
        uint256 valueBet = msg.value;
        address playerBet = msg.sender;

        // Criado o Player e atribuido já dentro do mapping
        addressToPlayer[playerBet].numberSelected = numberSelected;
        addressToPlayer[playerBet].amountBet = valueBet;

        totalBet += valueBet;
        players.push(playerBet);
    }

    function reset() public isOwner {
        delete players;
        totalBet = 0;
    }

    // private functions
    function generateWinnerNumber() private {
        uint256 numberPrize = 30; // (block.number + block.timestamp) % 10 + 1;
        rewardWinner(uint256(numberPrize));
    }

    function rewardWinner(uint256 numberPrizeGenerated) private {
        address[] memory winners; // Lista dos vencedores que selecionaram o numero correto
        uint256 count = 0;
        for(uint256 i = 0; i < players.length; i++) {
            address playerAddress = players[i];
            if(addressToPlayer[playerAddress].numberSelected == numberPrizeGenerated) {
                winners[count] = playerAddress;
                count++;
            }
        }

        //Limpar os apostadores (opcional)

        uint256  winnerEtherAmount = totalBet / count;
        for(uint256 j = 0; j < count; j++) {
            address payable payTo = payable(winners[j]);
            if(payTo != address(0)) {  //"0x000000000000000000000000000000"
                payTo.transfer(winnerEtherAmount);
            }
        }
    }

    // kill function
    function kill() public isOwner {
        // transferencia para todos os apostadores no valor das suas apostas
        selfdestruct(payable(owner));
    }
}