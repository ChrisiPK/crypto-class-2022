// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

contract FootballOracle {
    mapping (uint256 => bool) resultsAvailable;
    mapping (uint256 => uint256[2]) matchResults;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can execute this function!");
        _;
    }

    function getScore(uint matchId) public view returns(bool success, uint score1, uint score2) {
        return (resultsAvailable[matchId], matchResults[matchId][0], matchResults[matchId][1]);
    }

    function submitScore(uint256 matchId, uint256 score1, uint256 score2) public onlyOwner {
        require(resultsAvailable[matchId] == false, "This match result is already submitted, cannot resubmit!");
        (matchResults[matchId][0], matchResults[matchId][1]) = (score1, score2);
        resultsAvailable[matchId] = true;
    }
}
