// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserRegistry {
    struct UserInformation {
        string email;
        string phoneNumber;
        string name;
    }

    mapping(bytes32 => UserInformation) private users;
    mapping(bytes32 => bool) private isDuplicate;

    event UserAdded(string  email, string  phoneNumber, string  name);

   modifier isNotDuplicate(string memory _email, string memory _phoneNumber) {
    bytes32 userkey = keccak256(abi.encodePacked(_email, _phoneNumber));
    require(isDuplicate[userkey] == false, "User already exists");
    _;
}


    function addUser(string memory _email, string memory _phoneNumber, string memory _name)
        external
        isNotDuplicate(_email, _phoneNumber)
    {
                bytes32 userisDup = keccak256(abi.encodePacked(_email,_phoneNumber));
                isDuplicate[userisDup] = true;

        bytes32 userKey = keccak256(abi.encodePacked(_email));

        users[userKey] = UserInformation(_email, _phoneNumber, _name);

        emit UserAdded(_email, _phoneNumber, _name);
    }

    function getUserDetails(string memory _email)
        external
        view
        returns (string memory, string memory, string memory)
    {
        bytes32 userKey = keccak256(abi.encodePacked(_email));
        UserInformation memory user = users[userKey];
        require(bytes(user.email).length > 0, "User not found");
        return (user.email, user.phoneNumber, user.name);
    }
}


