// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract HotelReservation {

    /* state variables*/

    int roomsAvailable;
    int roomsBooked;
    uint costOfOneRoom;

    struct Room {
        bool reserved;
        address guest;
        int checkInDate;
    }

    struct Guest {
        int roomNo;
        string name;
        int contactNo;
        string email;
        int noOfGuests;
        address guest;
    }

    constructor (int _roomsAvailable, int _roomsBooked, uint _costOfOneRoom) {
        roomsAvailable = _roomsAvailable;
        roomsBooked = _roomsBooked;
        costOfOneRoom = _costOfOneRoom;
    }

    mapping(int => Room) public Rooms;
    mapping(address => Guest) public Guests;

    event roomBooking(int checkInDate, uint price, int roomNo, address guest);
    event roomCancelling(uint refund, int roomNo);

    function bookRoom(int _roomNo, int _checkInDate, string memory _name, int _contactNo, string memory _email, int _noOfGuests) public payable {
        require(roomsAvailable>0, "There are no rooms available");
        require(_roomNo>0 && _roomNo<roomsAvailable, "Room doesn't exist");
        require(msg.value >= costOfOneRoom, "Cost of one room is more than what you have paid");
        require(Rooms[_roomNo].reserved == false, "Room is already booked");

        roomsAvailable = roomsAvailable-1;
        roomsBooked = roomsBooked+1;
        Rooms[_roomNo].reserved = true;
        Rooms[_roomNo].guest = msg.sender;
        Rooms[_roomNo].checkInDate = _checkInDate;

        Guests[msg.sender].name = _name;
        Guests[msg.sender].noOfGuests = _noOfGuests;
        Guests[msg.sender].email = _email;
        Guests[msg.sender].contactNo = _contactNo;
        Guests[msg.sender].roomNo = _roomNo;
        emit roomBooking(_checkInDate, msg.value, _roomNo, msg.sender);
    }

    function cancelRoom(int _roomNo, int today) public {
        require(Rooms[_roomNo].reserved == true, "There's no such booking");
        require(Guests[msg.sender].roomNo == _roomNo, "U didn't book this room");
        roomsAvailable = roomsAvailable+1;
        roomsBooked = roomsBooked-1;
        Rooms[_roomNo].reserved = false;
        int checkInDate = Rooms[_roomNo].checkInDate;
        uint refund = 0;
        int timeForCheckIn = checkInDate-today;
        if(timeForCheckIn<=2){
            refund = 0;
        }
        else if(timeForCheckIn>=7){
            refund = costOfOneRoom;
        }
        else {
            refund = costOfOneRoom/2;
        }
        emit roomCancelling(refund, _roomNo);
    }


}
