// SPDX-License-Identifier: None
pragma solidity ^0.8.7;

abstract contract FootballOracle {
    // All matches are indexed. Returns whether query was successful,
    // alongside the scores
    function getScore(uint matchid) virtual public returns(bool success, uint score1, uint score2);
}

contract EmitMatchEvent {
    event MatchScore(uint matchid, uint score1, uint score2);

    FootballOracle public oracle;

    constructor(address _oracle) {
        oracle = FootballOracle(_oracle);
    }

    function checkScore(uint _matchid) public {
        bool success;
        uint score1;
        uint score2;

        // Fetch scores from the oracle
        (success, score1, score2) = oracle.getScore(_matchid);

        // If query works, tell world about the score!
        if (success) {
            emit MatchScore(_matchid, score1, score2);
        }
    }
}
