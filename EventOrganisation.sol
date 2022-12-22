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
        uint ticketRemaining;

    }

Event[] allEvents;

mapping(uint => Event) public Events;
mapping(address => mapping(uint => uint)) ticketBal;

uint eventId;

function allEventsInfo() view external returns(Event[] memory){
 
    return allEvents;

}



}