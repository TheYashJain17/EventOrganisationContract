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

modifier onlyOwner(){
    require(msg.sender == owner,"Only Owner Can Access This Function");
    _;
}

function allEventsInfo() view external returns(Event[] memory){
 
    return allEvents;

}

function registerEvent(string memory _name , uint _date , string memory _place , uint _price , uint _totalTickets , uint _remainingTickets) external onlyOwner{

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

function buyTickets(uint _eventId , uint _quantity) payable external{

    require(msg.sender != owner,"Owner Cannot Buy His/Her Own Tickets");

    Event memory _event = Events[_eventId];

    require(_event.date > block.timestamp , "Event Has Already Over");

    require(_event.remainingTickets > _quantity , "Sorry Tickets Are Not Avaiable");

    require(msg.value == _event.price * _quantity , "Price Should Be Equal To The Amount Of The Tickets");

    _event.remainingTickets -= _quantity;

    ticketBal[msg.sender][_eventId] += _quantity;


}

function transferTickets(uint _eventId , uint _quantity , address _to) external {

    require(msg.sender != owner , "Owner Cannot Transfer Tickets As He/She Doesn't Have Any Tickets");

    require(ticketBal[msg.sender][_eventId] > _quantity , "You Dont Have Enough Tickets To Transfer");

    Event memory _event = Events[_eventId];

    require(_event.date > block.timestamp , "Event Has Already Occured");

    ticketBal[msg.sender][_eventId] -= _quantity;

    ticketBal[_to][_eventId] += _quantity;


}


function viewBalance() view external onlyOwner returns(uint){

    return address(this).balance;

}

function withDrawBalance() payable external onlyOwner{

    require(msg.sender == owner,"Only Owner Can Call This Function");

    uint amount = address(this).balance;

    owner.transfer(amount);


}

function getTicketBal(uint _eventId) view  external returns(uint) {

    return ticketBal[msg.sender][_eventId];


}


}





  