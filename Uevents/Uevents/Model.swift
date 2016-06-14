//
//  Model.swift
//  Uevents
//
//  Created by Hansen Phanggestu on 14/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Model
{

// getting reference from the appDelegate
    let appDelegate =
    UIApplication.sharedApplication().delegate as! AppDelegate
    
    // Get a database context from the app delegate
    var managedContext: NSManagedObjectContext
        {
        get{
            return appDelegate.managedObjectContext
        }
    }
    
    // creating eventdb array
    var eventdb = [NSManagedObject]()
    
    // returning the data from the database
    func getEvent(indexPath: NSIndexPath) -> Event
    {
        return eventdb[indexPath.row] as! Event
    }
    
    
    //saving all the data into the database
    func saveEvent(name: String, date: NSDate, time: NSDate, desc: String, location: String, existing: Event?)
    {
        let entity = NSEntityDescription.entityForName("Event",
            inManagedObjectContext:managedContext)
        
        if let _ = existing
        {
            existing!.name = name
            existing!.date = date
            existing!.time = time
            existing!.desc = desc
            existing!.location = location
        }
        else
        {
            let event = Event(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            event.name = name
            event.desc = desc
            event.date = date
            event.time = time
            event.location = location
        }
        updateDatabase()
    }
    
    // Fetch the request from the "Event" core data
    func getEvent()
    {
        do
        {
            let fetchRequest = NSFetchRequest(entityName:"Event")
            
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            eventdb = results as! [Event]
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    //Deleting the event
    func deleteEvent(event: Event)
    {
        managedContext.deleteObject(event)
        updateDatabase()
    }
    
    // Updating/Reloading the database
    func updateDatabase()
    {
        do
        {
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    
    private struct Static
    {
        static var instance: Model?
    }
    
    
    class var sharedInstance: Model
    {
        if (Static.instance == nil)
        {
            Static.instance = Model()
        }
        return Static.instance!
    }
}
