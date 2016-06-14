//
//  TableViewController.swift
//  Uevents
//
//  Created by Hansen Phanggestu on 14/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//


import Foundation
import UIKit
import CoreData
import SwiftMoment

class TableViewController: UITableViewController
{
    
    var managedObjectContext: NSManagedObjectContext?
   
    let dateFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    var model:Model = Model.sharedInstance
    
    // Displaying the latest data
    override func  viewDidAppear(animated: Bool)
    {
        self.tableView.reloadData()
    }
    
    // Get the latest copy of Event from the model
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        model.getEvent()
    }
    
    
    //adding the data into the table view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.eventdb.count
    }
    
    
    //returning the data into the label provided in the table view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EventTableViewCell
        
        let event = model.getEvent(indexPath)
        cell.nameLabel.text = event.name
        cell.timeLabel.text = timeFormatter.stringFromDate(event.time!)
        cell.dateLabel.text = dateFormatter.stringFromDate(event.date!)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
        
        return cell
    }
    
    // Enable swipe to delete the rows
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    // System method that gets called when delete is selected
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        model.deleteEvent(model.eventdb[indexPath.row] as! Event)
        model.eventdb.removeAtIndex(indexPath.row)
        
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    //Segue methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        // Send data to the detail view ahead of segue
        if let selectedRowIndexPath = tableView.indexPathForSelectedRow
        {
        /* identifier is required, if you have more then one segue.
        We have two segues, one for adding a new item, and one for updating an existing one.
        If updating an existing one, we need to pass the current movie across so its data
        can be populated in the view. */
            if segue.identifier == "update" {
                let detailsEC: detailEventController! = segue.destinationViewController as! detailEventController
                let event = self.model.eventdb[selectedRowIndexPath.row]
                detailsEC.currentEvent = event as? Event
            }
        }
    }
    
    
    
    
    //Table view system method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
