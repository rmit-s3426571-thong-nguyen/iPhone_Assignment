//
//  calendarView.swift
//  Uevents
//
//  Created by Thong Nguyen on 18/04/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import UIKit
import CalendarView
import SwiftMoment


class calendarView: UIViewController {
    
    @IBOutlet weak var calendarTest: CalendarView!
    
    
    var date: Moment! {
        didSet{
            title = date.format("MMMM d, yyyy")
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        date = moment()
        calendarTest.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension calendarView : CalendarViewDelegate{
    func calendarDidSelectDate(date: Moment) {
        self.date = date
    }
    
    func calendarDidPageToDate(date: Moment) {
        self.date = date
    }
}
