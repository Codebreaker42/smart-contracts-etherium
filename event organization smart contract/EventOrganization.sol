// SPDX-License-Identifier: unlicense
pragma solidity >=0.5.0. <0.9.0;

contract EventOrganization{
    struct Event{
        address organizer;
        string eventName;
        uint date;
        uint price;
        uint totalTicket;
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;
    mapping(address=>mapping (uint=>uint)) public tickets;
    uint nextId;
    constructor(){

    }
    // function to create a event 
    function createEvent(string memory _name,uint _date,uint _price, uint _totalTicket) external {
        require(_date>block.timestamp,"You can orgnize Event for future Dates");
        require(_totalTicket>=1,"Total tickets for an Event should be more than equal to 1");
        events[nextId]=Event(msg.sender,_name,_date,_price,_totalTicket,_totalTicket); // initially the ticketRemain equal to _totalTicket
    }
}