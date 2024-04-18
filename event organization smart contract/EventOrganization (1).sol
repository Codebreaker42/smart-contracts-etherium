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
    mapping(address=>mapping (uint=>uint)) public tickets;// mapping address with eventId and tickets which means which address has which event tickets 
    uint nextId;
    constructor(){

    }
    // function to create a event 
    function createEvent(string memory _name,uint _date,uint _price, uint _totalTicket) external {
        require(_date>block.timestamp,"You can orgnize Event for future Dates");
        require(_totalTicket>=1,"Total tickets for an Event should be more than equal to 1");
        events[nextId]=Event(msg.sender,_name,_date,_price,_totalTicket,_totalTicket); // initially the ticketRemain equal to _totalTicket
        nextId++;
    }

    function buyTicket(uint id,uint quantity) external payable {
        require(events[id].date!=0,"This Event is not Exist");
        require(block.timestamp<events[id].date,"Event has already Occured");
        require(msg.value==(events[id].price*quantity),"Ether is not Enough to buy the Ticket");
        require(events[id].ticketRemain>=quantity,"Tickets are Not Availble");
        events[id].ticketRemain=events[id].ticketRemain-quantity;
        tickets[msg.sender][id]+=quantity;
    }
    function transferTickets(uint eventId, uint quantity, address to) external {
        require(events[eventId].date!=0,"This Event is not Exist");
        require(block.timestamp<events[eventId].date,"Event has already Occured");
        require(tickets[msg.sender][eventId]>=quantity,"You not have Enough Ticktes to Transfer");
        tickets[msg.sender][eventId]=tickets[msg.sender][eventId]-quantity;
        tickets[to][eventId]=tickets[to][eventId]+quantity;
    }
}