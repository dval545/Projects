//
//  Room.swift
//  Hotel
//
//  Created by Admin1 on 1/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import Foundation

struct Room: Equatable {
    var Id: Int
    var name: String
    var shortName: String
    var price: Int
    
    static var allRooms: [Room] {
        return [Room(Id: 1, name: "Regular", shortName: "R", price: 100), Room(Id: 2, name: "Suite", shortName: "S", price: 150),Room(Id: 3, name: "Grand Suite", shortName: "GS", price: 200)]
    }
    static func ==(room1: Room, room2: Room)-> Bool{
        return room1.Id == room2.Id
    }
}
