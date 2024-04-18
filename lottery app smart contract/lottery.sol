// SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.5.0 <0.9.0;
  /**
   * @title ContractName
   * @dev ContractDescription
   * @custom:dev-run-script file_path
   */
contract Lottery{
    address public  manager;
    address payable[] public  participants; //used to make lottery winning amount send to the winner participants
    // make constructor to give the priviledges to the manager
    constructor(){
        manager=msg.sender;  //gloabal variable to send the address to manager
    }

    // predefine function to take the ether from the participants as loterry ticket cost
    receive() external payable{          //this function only call one time in the contract and its not taking any parameter
        require(msg.value>=.001 ether,"Lottery ticket should more than .001 ether"); // if this condition is satisfy than the next line is executed
        participants.push(payable(msg.sender));       // push the address of the participants in array 
    } 

    function getBalance() public view returns(uint){
        require(msg.sender==manager,"you are not the manager"); // only manager can see the balance of a contract
        return address(this).balance;
    }

    // create a function to generate random value
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length))); //generate a 64 bit random number
    }

    //function to choose a winner
    function getWinner() public returns(address){
        require(msg.sender==manager,"only the manager can choose the Winner");
        require(participants.length>=3,"At least 3 participants should be in the lottery contest");

        uint rand=random();
        address payable winner;
        uint index=rand%participants.length;
        winner=participants[index];
        winner.transfer(getBalance());
        // empty the participants dynamic array
        participants=new address payable[](0);
        return winner;
    }
}