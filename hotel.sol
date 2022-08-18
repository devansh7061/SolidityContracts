pragma solidity ^0.8.0;

contract HotelReservation{
    
    struct Room{
        bool reserved;
        address guest;
        int checkInDate;
    }
    struct Guest{
        address guest;
        int roomNum;
    }
    mapping(int => Room) public rooms;

    int public roomsAvailable;
    int public roomsBooked;
    uint public roomPriceInEth;
    constructor() {
        roomsAvailable = 2;
        roomsBooked = 0;
        roomPriceInEth = 1;
    }
    event roomReserved(int roomNum, int checkInDate, address guest, uint price);
    
    function bookRoom(int _roomNum, int _checkIn) public payable {
        require(roomsAvailable>0, "Sorry, all the rooms are booked");
        require(msg.value>=roomPriceInEth, "U can't afford a room, kindly fuck off");
        require(_roomNum>0 && _roomNum<=roomsAvailable, "Room doesn't exist");
        require(rooms[_roomNum].reserved == false, "Room is already booked");
        roomsAvailable-=1;
        roomsBooked+=1;
        rooms[_roomNum].reserved  = true;
        rooms[_roomNum].guest  = msg.sender;
        rooms[_roomNum].checkInDate  = _checkIn;
        emit roomReserved(_roomNum, 5, msg.sender, msg.value);
    }

    event bookingCancellation(int roomNum, address guest, uint refund);

    function cancelRoom(int _roomNum, int today) public{
        require(rooms[_roomNum].reserved == true, "Nashe kmm krro");
        uint refund = 0;
        roomsAvailable+=1;
        roomsBooked-=1;
        rooms[_roomNum].reserved = false;
        if(rooms[_roomNum].checkInDate-today>=7){
            refund = roomPriceInEth;
        }
        else if(rooms[_roomNum].checkInDate-today>=2){
            refund = roomPriceInEth/2;
        }
        else refund = 0;
        emit bookingCancellation(_roomNum, msg.sender, refund);
    }
}
