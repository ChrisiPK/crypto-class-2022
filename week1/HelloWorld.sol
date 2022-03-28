// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract HelloWorld {
    event Message(string);

    string public message;
    string[] public messageHistory;
    mapping(address => string[]) messageUpdaters;
    address lastUpdater;

    constructor() {
        updateMessage("Hello World!");
    }

    function hello () public returns (string memory) {
        emit Message(message);
        return message;
    }

    function updateMessage(string memory _message) public {
        message = _message;
        messageHistory.push(_message);
        messageUpdaters[msg.sender].push(_message);
        lastUpdater = msg.sender;
    }

    function getMessage(address user, uint i) public view returns (string memory) {
        return messageUpdaters[user][i];
    }

    function latestMessage() public view returns (string memory, address) {
        return (message, lastUpdater);
    }
}
