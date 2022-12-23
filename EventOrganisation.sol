//SPDX-License-Identifier:MIT

pragma solidity ^0.8.9;

contract eventOrg{

    struct Event{

        string name;
        uint date;
        string place;
        uint price;
        uint id;
        uint totalTickets;
        uint remainingTickets;

    }

Event[] allEvents;

mapping(uint => Event) public Events;
mapping(address => mapping(uint => uint)) ticketBal;

address owner;
uint eventId;

constructor(){
    owner = msg.sender;
}

function allEventsInfo() view external returns(Event[] memory){
 
    return allEvents;

}

function registerEvent(string memory _name , uint _date , string memory _place , uint _price , uint _totalTickets , uint _remainingTickets) external{

    require(msg.sender == owner,"Only Owner Can Register An Event");

    require(_date > block.timestamp,"You Can Organize Events For Future Date Only");

    require(_totalTickets > 0,"You Have To Create More Than 0 Tickets");

    Event memory _event;

    _event.name = _name;
    _event.date = _date;
    _event.place = _place;
    _event.price = _price;
    _event.id = eventId;
    _event.totalTickets = _totalTickets;
    _event.remainingTickets = _remainingTickets;

    Events[eventId] = _event;

    allEvents.push(_event);

    eventId++;

}





}