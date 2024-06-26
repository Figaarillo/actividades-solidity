// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {
    mapping (string => uint256) public votesReceived;
    string[] private candidateList;

    constructor(string[] memory candidates) {
        candidateList = candidates;
    }

    function voteForCandidate(string memory candidate) public {
        require(validateIfIsAValidCandidate(candidate), "Candidate is not valid");
        votesReceived[candidate]++;
    }

    function totalVotesFor(string memory candidate) public view returns (uint256) {
        require(validateIfIsAValidCandidate(candidate), "Candidate is not valid");
        return votesReceived[candidate];
    }

    function validateIfIsAValidCandidate(string memory candidateName) private view returns (bool) {
        for (uint256 i = 0; i < candidateList.length; i++) {
            if (keccak256(abi.encodePacked(candidateName)) == keccak256(abi.encodePacked(candidateList[i]))) {
                return true;
            }
        }
        return false;
    }

    function viewCompleteListOfCandidateVotes() public view returns (string[] memory, uint256[] memory) {
        uint256[] memory votes = new uint256[](candidateList.length);
        for (uint256 i = 0; i < candidateList.length; i++) {
            votes[i] = votesReceived[candidateList[i]];
        }
        return (candidateList, votes);
    }
}
