//
//  UeventsTests.swift
//  UeventsTests
//
//  Created by Nicholas Amor on 21/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import XCTest
import CoreData

@testable import Uevents

class UeventsTests: XCTestCase {
    
    var model: Model?
    
    override func setUp() {
        super.setUp()
        
        model = Model.sharedInstance
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
     * Test saving to the database
     */
    func testAdd() {
        guard let model = model else {
            XCTAssert(false)
            return
        }
        
        let oldCount = model.eventdb.count
       
        let random = Int(arc4random_uniform(99) + 1)
        
        model.saveEvent("New Event \(random)", date: NSDate(), time: NSDate(), desc: "Test Event", location: "Darling Harbour", existing: nil)
        
        model.getEvent()
        
        let newCount = model.eventdb.count
        
        XCTAssert(newCount > oldCount)
    }
    
    func testGetEvent() {
        guard let model = model else {
            XCTAssert(false)
            return
        }
        
        model.saveEvent("Test Get Event", date: NSDate(), time: NSDate(), desc: "Test Event", location: "Darling Harbour", existing: nil)
        
        model.getEvent()
        
        XCTAssert(model.getEvent(NSIndexPath(index: model.eventdb.count)) == "Test Get Event")
    }
    
    func testUpdateEvent() {
        guard let model = model else {
            XCTAssert(false)
            return
        }
        
        model.saveEvent("bla", date: NSDate(), time: NSDate(), desc: "Test Event", location: "Darling Harbour", existing: nil)
        
        model.getEvent()
        
        let event = model.eventdb.last as! Event
        
        model.saveEvent("Updated Event", date: NSDate(), time: NSDate(), desc: "desc", location: "Darling Harbour", existing: event)
        
        model.getEvent()
        
        let updatedEvent = model.eventdb.last as! Event

        XCTAssert(updatedEvent.name! == "Updated Event")
    }
    
    func testDeleteEvent() {
        guard let model = model else {
            XCTAssert(false)
            return
        }
        
        let oldCount = model.eventdb.count
        
        model.saveEvent("Test Delete Event", date: NSDate(), time: NSDate(), desc: "Test Event", location: "Darling Harbour", existing: nil)
        
        model.getEvent()
        
        let event = model.eventdb.last as! Event
        
        model.deleteEvent(event)
        
        model.getEvent()
        
        let newCount = model.eventdb.count

        XCTAssert(newCount == oldCount)
    }
    
    func testDeleteAllEvents() {
        guard let model = model else {
            XCTAssert(false)
            return
        }
        
        for event in model.eventdb {
            let nsevent = event as! Event
            model.deleteEvent(nsevent)
        }
        
        model.getEvent()
        
        XCTAssert(model.eventdb.count == 0)
    }
    
}
