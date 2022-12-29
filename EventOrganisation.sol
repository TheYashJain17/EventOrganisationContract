//SPDX-License-Identifier:MIT

pragma solidity ^0.8.9;

contract eventOrg{

//Creating An Event For Storing The Information Of Our Event.

    struct Event{

        string name;
        uint date;
        string place;
        uint price;
        uint id;
        uint totalTickets;
        uint remainingTickets;

    }

//Making A Dynamic Array With The Struct We Created Above.

Event[] allEvents;

//Initialised A Mapping To Store An Event On A Particular Id.

mapping(uint => Event) public Events;

//Initialised A Mapping To Store The Balance Of The Tickets Of A Particular Event On Particular Address.

mapping(address => mapping(uint => uint)) ticketBal;

//Declaring A State Variable Of Address Type Which Gonna Store Our Owner.

address payable owner;

//Declaring A State Variable Of Uint Type To Store Our Event's Id.

uint eventId;

//Initialised A Constructor To Initialise Our owner.

constructor(){
    owner = payable(msg.sender);
}

//Initialised A Modifier To Create A onlyOwner Modifier.

modifier onlyOwner(){
    require(msg.sender == owner,"Only Owner Can Access This Function");
    _;
}

//Created A Function To Know About All The Events Together.

function allEventsInfo() view external returns(Event[] memory){
 
    return allEvents;

}

//Created A Function To Register/Create An Event.

function registerEvent(string memory _name , uint _date , string memory _place , uint _price , uint _totalTickets , uint _remainingTickets) external onlyOwner{

    require(_date > block.timestamp,"You Can Organize Events For Future Date Only");

    require(_totalTickets > 0,"You Have To Create More Than 0 Tickets");

    Event memory _event;    //Storing The Struct Into A Temporary Variable.

    _event.name = _name;
    _event.date = _date;
    _event.place = _place;
    _event.price = _price;
    _event.id = eventId;
    _event.totalTickets = _totalTickets;
    _event.remainingTickets = _remainingTickets;

    Events[eventId] = _event;   //Setting The Event On A Particular Id.

    allEvents.push(_event);     //Pushing The Event In allEvents Array.

    eventId++;      //Incrementing The Event Id.

}

//Created A Function To Buy The Tickets.

function buyTickets(uint _eventId , uint _quantity) payable external{

    require(msg.sender != owner,"Owner Cannot Buy His/Her Own Tickets");

    Event memory _event = Events[_eventId]; //Storing The Struct Into A Temporary Variable And Inside it Storing The Event Id.

    require(_event.date > block.timestamp , "Event Has Already Over");

    require(_event.remainingTickets > _quantity , "Sorry Tickets Are Not Avaiable");

    require(msg.value == _event.price * _quantity , "Price Should Be Equal To The Amount Of The Tickets");

    _event.remainingTickets -= _quantity;   //Deducting The Required Tickets Of The Demanded Event From The Total Tickets.

    ticketBal[msg.sender][_eventId] += _quantity;   //Adding The Required Tickets Of The Demanded Event On Particular Address.


}

//Made A Function To Transfer The Tickets.

function transferTickets(uint _eventId , uint _quantity , address _to) external {

    require(msg.sender != owner , "Owner Cannot Transfer Tickets As He/She Doesn't Have Any Tickets");

    require(ticketBal[msg.sender][_eventId] > _quantity , "You Dont Have Enough Tickets To Transfer");

    Event memory _event = Events[_eventId];     //Storing The Struct Into A Temporary Variable.

    require(_event.date > block.timestamp , "Event Has Already Occured");

    ticketBal[msg.sender][_eventId] -= _quantity;   //Deducting The Required Tickets From The Account We Are Transfering The Tickets.

    ticketBal[_to][_eventId] += _quantity;  //Adding The Required Tickets To The Account We Are Transfering The Tickets To.


}

//Made A Function Through Which Owner Can Check The Balance Of The Contract.

function viewBalance() view external onlyOwner returns(uint){

    return address(this).balance;

}

//Made A Function Through Which Owner Can Withdraw The Balance Of The Contract.

function withDrawBalance() payable external onlyOwner{

    require(msg.sender == owner,"Only Owner Can Call This Function");

    uint amount = address(this).balance;

    owner.transfer(amount);


}

//Made A Function Through Which Buyer Can See The Balance Of The Tickets (Of The Particular Event) He/She is Remaining With.

function getTicketBal(uint _eventId) view  external returns(uint) {

    return ticketBal[msg.sender][_eventId];

}

}
 
