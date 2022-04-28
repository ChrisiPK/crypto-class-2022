// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract RockPaperScissorsLizardSpock {
    enum Move {
        Rock,
        Paper,
        Scissors,
        Lizard,
        Spock
    }

    int8[5][5] public checkWinner = [
        [int8(0), int8(-1), int8(1), int8(1), int8(-1)],
        [int8(1), int8(0), int8(-1), int8(-1), int8(1)],
        [int8(-1), int8(1), int8(0), int8(1), int8(-1)],
        [int8(-1), int8(1), int8(-1), int8(0), int8(1)],
        [int8(1), int8(-1), int8(1), int8(-1), int8(0)]
    ];

    event Winner(address winner, uint256 amount);
    event Tie(address playerOne, address PlayerTwo, uint256 amount);
    event TimeOut(address winner, uint256 amount);

    uint constant timeout = 60;

    mapping(address => uint256) balances;
    uint256 potSize;

    address playerOne;
    bytes32 hiddenMovePlayerOne;
    bool playerOneRevealed;
    Move movePlayerOne;
    uint256 gameStarted;

    address playerTwo;
    Move movePlayerTwo;
    uint256 playerTwoMoveSubmitted;

    function startGame(bytes32 move) public payable {
        require(playerOne == address(0), "Cannot start another game, a game is already running!");
        potSize = msg.value;
        playerOne = msg.sender;
        hiddenMovePlayerOne = move;
        gameStarted = block.timestamp;
    }

    function joinGame(Move move) public payable {
        require(msg.value == potSize, "Please supply exactly as many coins as are already in the pot!");
        potSize += msg.value;
        playerTwo = msg.sender;
        playerTwoMoveSubmitted = block.timestamp;
        movePlayerTwo = move;
    }

    function revealMove(Move move, uint256 nonce) public {
        bytes32 hashed = keccak256(abi.encode(move, nonce));
        assert(hashed == hiddenMovePlayerOne);
        movePlayerOne = move;
        playerOneRevealed = true;
    }

    function completeGame() public {
        require(playerOne != address(0), "No game is running!");
        if (playerTwo == address(0)) {
            require(block.timestamp >= gameStarted + timeout, "Games with only one player can only be completed after timeout.");
            balances[playerOne] += potSize;
            emit TimeOut(playerOne, potSize);
        } 
        else if (!playerOneRevealed) {
            require(block.timestamp >= playerTwoMoveSubmitted + timeout, "Cannot end game before Player One has had time to reveal their move.");
            balances[playerTwo] += potSize;
            emit TimeOut(playerTwo, potSize);
        } else {
            int8 winner = checkWinner[uint(movePlayerOne)][uint(movePlayerTwo)];
            if (winner > 0) {
                balances[playerOne] += potSize;
                emit Winner(playerOne, potSize);
            } else if (winner < 0) {
                balances[playerTwo] += potSize;
                emit Winner(playerTwo, potSize);
            } else {
                balances[playerOne] += potSize / 2;
                balances[playerTwo] += potSize / 2;
                emit Tie(playerOne, playerTwo, potSize);
            }
        }

        delete potSize;
        delete playerOne;
        delete hiddenMovePlayerOne;
        delete playerOneRevealed;
        delete movePlayerOne;
        delete gameStarted;
        delete playerTwo;
        delete movePlayerTwo;
        delete playerTwoMoveSubmitted;
    }

    function withdraw(address target) public {
        require(balances[msg.sender] > 0, "Cannot withdraw without a balance!");
        uint256 balanceToTransfer = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool success,) = target.call{value: balanceToTransfer}("");
        if (!success) {
            balances[msg.sender] = balanceToTransfer;
        }
    }
}
