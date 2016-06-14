//
//  loginController.swift
//  Uevents
//
//  Created by Thong Nguyen on 13/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn

class loginController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    let ref = FIRDatabase.database().reference()
    
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // debug print login status
        FIRAuth.auth()!.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                print(user.uid)
            } else {
                print("No user is signed in")
            }
        }
        
        // setup delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        
        //Atempt to sign in sliently
        //this will succeed if user logged in
       
    }
    // wire up to a button tap
    func authenticateWithGoogle(sender: GIDSignInButton){
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signOut(){
        GIDSignIn.sharedInstance().signOut()
        try! FIRAuth.auth()!.signOut()
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        
        guard error == nil else {
            print(error)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signInWithCredential(credential, completion: {(user, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            let userPro: NSDictionary = [
                "User Name": user!.displayName!,
                "User Email": user!.email!
            ]
            let userWho = self.ref.child("Users")
            let userProfile = userWho.child(user!.uid)
            userProfile.setValue(userPro)
            
            self.performSegueWithIdentifier("LoginToChat", sender: nil)
        })
        
    }
    
    func goToNextView(sender: GIDSignInButton!) {
        self.performSegueWithIdentifier("Rmit", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        guard let user: FIRUser = FIRAuth.auth()!.currentUser! else {
            return
        }
        
        let tabVc = segue.destinationViewController as! UITabBarController
        let chatVc = tabVc.viewControllers![2] as! chatController
        
        chatVc.senderId = user.uid
        chatVc.user = user
        chatVc.senderDisplayName = user.displayName!
        
        // Populate settings page fields
        let settingsController = tabVc.viewControllers![3] as! SettingsController
        settingsController.userName = user.displayName!
        settingsController.email = user.email!
    }
}
