// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";

contract Create {
    using Counters for Counters.Counter;
    Counters.Counter public _voterID;
    Counters.Counter public _candidateID;

    address public votingOrganizer;

    struct Candidate {
        uint256 candidateID;
        string age;
        string name;
        string img;
        uint256 voteCount;
        address _address;
        string ipfs;
    }

    event CandidateCreate (
        uint256 indexed candidateID,
        string age,
        string name,
        string img,
        uint256 voteCount,
        address _address,
        string ipfs
    );

    address[] public CandidateAddress;
    mapping(address => Candidate) public candidates;

    //voter data

    address[] public votedVoters;
    address[] public votersAddress;

    struct Voter{
        uint256 voter_voterID;
        string voterName;
        string voterImg;
        address voterAddress;
        uint256 voterAllowed;
        bool voterVoted;
        uint256 voterVote;
        string voterIpfs;
    }
    event VoterCreated(
       uint256 indexed voter_voterID,
        string voterName,
        string voterImg,
        address voterAddress,
        uint256 voterAllowed,
        bool voterVoted,
        uint256 voterVote,
        string voterIpfs
    );
    mapping (address => Voter) public voters; 
    
    constructor(){
        votingOrganizer = msg.sender;
    }

    function setCandidate(address _address, string memory _age,string memory _name,string memory _img, string memory _ipfs  )public{
        require(votingOrganizer == msg.sender, "Only organizer can add new candidate");

        _candidateID.increment();

        uint256 idNumber = _candidateID.current();

        Candidate storage candidate = candidates[_address];
        candidate.age = _age;
        candidate.name = _name;
        candidate.candidateID = idNumber;
        candidate.img = _img;
        candidate.voteCount = 0;
        candidate._address = _address;
        candidate.ipfs = _ipfs;

        CandidateAddress.push(_address);

        emit CandidateCreate(
           idNumber,
           _age,
           _name,
           _img,
           candidate.voteCount,
           _address,
           _ipfs
        );
        
    }

    function getCandidate() public view returns(address[] memory){
        return CandidateAddress;
    }
    
    function getCandidateLength()public view returns (uint256){
        return CandidateAddress.length;
    }

    function getCandidateData(address _address) public view returns(string memory, string memory,uint256, string memory,uint256,string memory, address){

      return(
        candidates[_address].age,
        candidates[_address].name,
        candidates[_address].candidateID,
        candidates[_address].img,
        candidates[_address].voteCount,
        candidates[_address].ipfs,
        candidates[_address]._address
      );
    }
    
    function voterRight(address _address,string memory _name, string memory _img, string memory _ipfs)public{
      
      require(votingOrganizer == msg.sender, "Only organizer can create voter");

      _voterID.increment();

      uint256 idNumber = _voterID.current();

      Voter storage voter = voters[_address];

      require(voter.voterAllowed == 0);

      voter.voterAllowed = 1;
      voter.voterName = _name;
      voter.voterImg = _img;
      voter.voterAddress = _address;
      voter.voter_voterID = idNumber;
      voter.voterVote = 1000;
      voter.voterVoted = false;
      voter.voterIpfs = _ipfs;


      votersAddress.push(_address);

      emit VoterCreated(idNumber, _name, _img, _address, voter.voterAllowed, voter.voterVoted, voter.voterVote, _ipfs);
    }


    function vote(address _candidateAddress,uint256 _candidateVoteId) external{
        Voter storage voter = voters[msg.sender];

        require(!voter.voterVoted, "You have already voted");
        require(voter.voterAllowed !=0, "You have no right to vote");

        voter.voterVoted = true;
        voter.voterVote = _candidateVoteId;

        votedVoters.push(msg.sender);

        candidates[_candidateAddress].voteCount += voter.voterAllowed;

    }

    function getVoterLength() public view returns(uint256){
        return votersAddress.length;
    }

    function getVoterData(address _address) public view returns(uint256, string memory, string memory, address, string memory,uint256,bool){
        return (
            voters[_address].voter_voterID,
            voters[_address].voterName,
            voters[_address].voterImg,
            voters[_address].voterAddress,
            voters[_address].voterIpfs,
            voters[_address].voterAllowed,
            voters[_address].voterVoted
            


        );
    }

    function getVotedVotersList() public view returns (address[] memory){
        return votedVoters;
    }

    function getVoterList() public view returns (address[] memory){
        return votersAddress;
    }

}
