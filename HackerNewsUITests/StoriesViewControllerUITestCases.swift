//
//  StoriesViewControllerUITestCases.swift
//  HackerNews
//
//  Created by Siva Cherukuri on 04/02/17.
//  Copyright © 2017 Ducere. All rights reserved.
//

@testable import HackerNews
import XCTest

class StoriesViewControllerUITestCases: XCTestCase
{
        
    override func setUp()
    {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }
    
    func testBasicAppLaunch() {
        
        // application: Proxy for the tested application
        //Tests run in a separate process
        let app = XCUIApplication()
        app.launch()
        
        // assertion:
        XCTAssertEqual(app.tables.count, 1)
        
        //Verifying the current controller's title
        XCTAssert(app.navigationBars["Hacker News"].exists)

    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
