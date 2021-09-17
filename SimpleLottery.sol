pragma solidity ^0.4.24;

contract Lottery{
    address[] public players; // dynamic array with players addresses
    address public manager; // contract manager
    
    // contract constructor, runs once at contract deployment
    constructor() public{
        manager = msg.sender; // the manager is account address that deploys the contract
    }
    
    // this fallback payable function will be automatically colled when somebody send ether
    // to our contract address
    function () payable public{
        require(msg.value >= 0.01 ether);
        players.push(msg.sender); // add the address ether sender to "players" array
    }
    
    function get_balance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance; // return contract balance
    }
    
    function random() public view returns(uint256){
        return uint256(keccak256(block.difficulty, block.timestamp, players.length)); // !!! not perfect random - only for example
    }

    // we can add for visual test only!!! "view returns(address)" in function string & "return winner;" in the end of function
    function selectWinner() public{ 
        require(msg.sender == manager);

        uint r = random();

        address winner;

        uint index = r % players.length;
        winner = players[index];

        // !!!transfer contract balance to the "winner" (In fact, some percentage should go to the organizers)
        winner.transfer(address(this).balance);

        // resetting the players dynamic array
        players = new address[](0);
    }
}