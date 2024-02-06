// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract VendingMachineV3 is Initializable {
  // these state variables and their values
  // will be preserved forever, regardless of upgrading
  uint public numSodas;
  address public owner;
  mapping(address =>  uint) public sodasPurchased;

  function initialize(uint _numSodas) public initializer {
    numSodas = _numSodas;
    owner = msg.sender;
  }

  function purchaseSoda(uint _sodaCount) public payable {
    require(msg.value >= 1000 wei * _sodaCount, "You must pay 1000 wei per soda!");
    require(numSodas >= _sodaCount, "Not enough sodas in stock to satisfy order" );
    uint totalCost = 1000 wei * _sodaCount;
    uint change = msg.value - totalCost;
    numSodas -= _sodaCount;
    sodasPurchased[msg.sender] += _sodaCount;
        if (change > 0) {
            (bool sent, ) = msg.sender.call{value: change}("");
            require(sent, "Issue processing transaction");
        }
  }

  function withdrawProfits() public onlyOwner {
    require(address(this).balance > 0, "Profits must be greater than 0 in order to withdraw!");
    (bool sent, ) = owner.call{value: address(this).balance}("");
    require(sent, "Failed to send ether");
  }

  function setNewOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
  }

  function userSodaCount(address _userAddress) view returns (uint) {
    return sodasPurchased[_userAddress];
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function.");
    _;
  }
}