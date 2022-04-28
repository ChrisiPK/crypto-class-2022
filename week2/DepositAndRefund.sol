// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

contract DepositAndRefund {
    mapping(address => uint) balances;

    function getBalance(address party) public view returns(uint) {
        return balances[party];
    }

    function deposit() public payable {
        require(msg.value > 0 ether);
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
