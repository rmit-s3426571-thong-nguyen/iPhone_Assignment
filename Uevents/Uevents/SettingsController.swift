//
//  SettingsController.swift
//  Uevents
//
//  Created by Nicholas Amor on 16/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

/**
 Displays user name and email, allows user to log out
 */
class SettingsController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var userName: String = ""
    var email: String = ""
    
    let ref = FIRDatabase.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = userName
        emailLabel.text = email
    }
    
    @IBAction func logout(sender: UIButton) {
        
    }
}
