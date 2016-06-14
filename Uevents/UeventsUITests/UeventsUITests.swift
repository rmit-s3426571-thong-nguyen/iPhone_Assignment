//
//  UeventsUITests.swift
//  UeventsUITests
//
//  Created by Thong Nguyen on 10/04/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import XCTest

class UeventsUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //test that when tap "Sign Up" button will show Sign Up Screen.
        //after done signing up tap "Create an account" take the user back to the login screen.
        
        let app = XCUIApplication()
        app.buttons["Sign Up"].tap()
        app.buttons["  Create an account "].tap()
        
    }

        

    
    
    
}
