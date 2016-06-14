//
//  Events.swift
//  Uevents
//
//  Created by Thong Nguyen on 21/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import Foundation

class Events {
    
    var events = [
        "Wed  May 25, Something new will happen at RMIT!",
        "Thur  May 26, Nothing new will happen at RMIT!",
        "Fri  May 27, Who knows what happen at RMIT!",
        "Sat  May 28, YAY weekend!!! "
    ]
    
    func randomEvents() -> String {
        return events[Int(arc4random_uniform(UInt32(events.count)))]
    }
}