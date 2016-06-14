//
//  TodayViewController.swift
//  TodayUevents
//
//  Created by Thong Nguyen on 21/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//
//  These codes has been following this tutorial
//  http://www.ios-blog.co.uk/tutorials/swift/create-today-widget-extension/
//  Educational purposes only
import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var openApp: UIButton!

    @IBOutlet weak var eventText: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.

        let displayEvent = Events()
        eventText.text = displayEvent.randomEvents()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }

    //slightly pushed to the right.
    //fix text lable to middle
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    @IBAction func launchApp(sender: UIButton) {
        let appURL:NSURL = NSURL(string: "com.romakin.FirebaseTest://")!
        self.extensionContext?.openURL(appURL, completionHandler: nil)
        print("Tapped")
    }

}
