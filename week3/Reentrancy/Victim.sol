// SPDX-License-Identifier: None
pragma solidity ^0.8.7;

contract Victim {
    uint256 toTransfer = 1 ether;

    // Only 1 ether can be sent by this contract
    function withdraw() public payable {
        // Send 1 coin
        msg.sender.call{value: toTransfer}('');
        // Deduct balance by 1
        toTransfer = 0;
    }

    // Use deposit() to send 10 ether to contract
    function deposit() public payable {}
}
