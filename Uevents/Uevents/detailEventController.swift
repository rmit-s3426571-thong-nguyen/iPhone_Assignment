//
//  detailEventController.swift
//  Uevents
//
//  Created by Hansen Phanggestu on 14/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class detailEventController:UIViewController{
    var model:Model = Model.sharedInstance
    var currentEvent:Event?
    
    
    let dateFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    
    
    // Link all the button/label to the controller
    @IBOutlet var nameInput: UITextView!
    @IBOutlet var descInput: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateInput: UITextField!
    @IBOutlet weak var timeInput: UITextField!
    @IBOutlet var locationInput: UITextField!
    
    //overriding the data label with the current data in the core map
    override func viewDidLoad()
    {
        descInput!.layer.borderWidth = 1
        descInput!.layer.borderColor = UIColor.lightGrayColor().CGColor
        super.viewDidLoad()
        if let _ = currentEvent
        {
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            nameInput.text = currentEvent!.name
            descInput.text = currentEvent!.desc
            dateInput.text = dateFormatter.stringFromDate(currentEvent!.date!)
            timeInput.text = timeFormatter.stringFromDate(currentEvent!.time!)
            locationInput.text = currentEvent!.location
            
            updateMapView(currentEvent!.location!)
        }
    }
    
    
    // Display the date picker
    @IBAction func datePickerTapped(sender: AnyObject) {
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        DatePickerDialog().show("Choose the date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
            (date) -> Void in
            self.dateInput.text = self.dateFormatter.stringFromDate(date)
            }
        }
    
    //Display the time picker
    @IBAction func timePickerTapped(sender: AnyObject) {
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        DatePickerDialog().show("Choose the time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) {
            (time) -> Void in
            self.timeInput.text = self.timeFormatter.stringFromDate(time)
        }
    }
    
    //save the data into the core data
    func save(sender: AnyObject) {
        if let text = nameInput.text where !text.isEmpty
        {
            
            let date = dateFormatter.dateFromString(dateInput.text!)!
            let time = timeFormatter.dateFromString(timeInput.text!)!
            Model.sharedInstance.saveEvent( nameInput.text, date: date, time: time, desc: descInput.text!,location: locationInput.text!, existing: currentEvent)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
            let alertController = UIAlertController(title: "Warning", message:
                "Please input your Event Name!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Updating the core map with the inputted location
    func updateMapView(address: String) {
        // Create a Coordinate Locator
        let geoCoder = CLGeocoder()
        var coords: CLLocationCoordinate2D?
        
        // Determine the zoom level of the map to display
        let span = MKCoordinateSpanMake(0.01, 0.01)
        
        geoCoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemarks?[0] {
                
                // Convert the address to a coordinate
                let location = placemark.location
                coords = location!.coordinate
                
                // Set the map to the coordinate
                let region = MKCoordinateRegion(center: coords!, span: span)
                self.mapView.region = region
                
                // Add a pin to the address location
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
            }
        })
    }
}
