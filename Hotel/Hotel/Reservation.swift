//
//  Reservation.swift
//  Hotel
//
//  Created by Admin1 on 1/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import Foundation

struct Reservation {
    var guestName: String
    var guestLastName: String
    var email: String
    
    var checkIn: Date
    var checkOut: Date
    var adultsNumber: Int
    var childrenNumber: Int
    
    var roomChoice: Room
    var wifi: Bool
}
