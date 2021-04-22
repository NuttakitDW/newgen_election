// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
// specifies what version of compiler this code will be compiled with

contract Voting {
  /* the mapping field below is equivalent to an associative array or hash.
  */

  mapping (string => uint256) votesReceived;
  mapping (address => uint256) votesPoint;

  /* Solidity doesn't let you pass in an array of strings in the constructor (yet).
  We will use an array of bytes32 instead to store the list of candidates
  */

  string[] public candidateList;
  address[] public voterList;
  address owner;

  /* Broadcast event when a user voted
  */
  event VoteReceived(address user, string candidate, uint256 amount);
  event PointReceived(address user, address voter, uint256 amount);

  /* This is the constructor which will be called once and only once - when you
  deploy the contract to the blockchain. When we deploy the contract,
  we will pass an array of candidates who will be contesting in the election
  */
  constructor(string[] memory candidateNames, address[] memory voterAddress) public {
    candidateList = candidateNames;
    voterList = voterAddress;
    owner = msg.sender;
  }

  // This function returns the total votes a candidate has received so far
  function totalVotesFor(string memory candidate) public view returns (uint256) {
    return votesReceived[candidate];
  }
  
  function totalPointFor(address voter) public view returns (uint256) {
    return votesPoint[voter];
  }

  // This function increments the vote count for the specified candidate. This
  // is equivalent to casting a vote
  function voteForCandidate(string memory candidate, uint amount) public {
    require(votesPoint[msg.sender] >= amount);
    votesReceived[candidate] += amount;
    votesPoint[msg.sender] -= amount;

    // Broadcast voted event
    emit VoteReceived(msg.sender, candidate, amount);
  }
  
  function pointForVoter(address voter, uint amount) public {
    require(msg.sender == owner);
    votesPoint[voter] += amount;

    // Broadcast voted event
    emit PointReceived(msg.sender, voter, amount);
  }

  function candidateCount() public view returns (uint256) {
      return candidateList.length;
  }
  
  function voterCount() public view returns (uint256) {
      return voterList.length;
  }
}
