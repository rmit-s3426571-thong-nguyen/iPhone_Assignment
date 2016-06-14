//
//  Event.swift
//  Uevents
//
//  Created by Nicholas Amor on 15/04/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject
{
    
    @NSManaged var desc: String?
    @NSManaged var name: String?
    @NSManaged var time: NSDate?
    @NSManaged var date: NSDate?
    @NSManaged var location:String?
}