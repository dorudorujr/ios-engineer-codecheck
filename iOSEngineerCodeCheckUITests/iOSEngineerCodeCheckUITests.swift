//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
import RealmSwift

class iOSEngineerCodeCheckUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        XCUIApplication().launch()
    }
    
    func test_search() {
        let app = XCUIApplication()
        let searchBar = app.searchFields.element
        searchBar.tap()
        searchBar.typeText("Swift")
        app.keyboards.buttons["Search"].tap()
        sleep(3)
        let tableView = app.tables.element
        let cellCount = tableView.cells.count
        XCTAssertTrue(cellCount > 0)
    }
    
    func test_transition_to_detail() {
        let app = XCUIApplication()
        let searchBar = app.searchFields.element
        searchBar.tap()
        searchBar.typeText("Swift")
        app.keyboards.buttons["Search"].tap()
        sleep(3)
        let tableView = app.tables.element
        let cell = tableView.cells.element(boundBy: 0)
        cell.tap()
        sleep(2)
        
        XCTAssertTrue(app.navigationBars["検索画面"].buttons["love"].exists)
        XCTAssertTrue(app.images["AvatarImage"].exists)
        XCTAssertTrue(app.staticTexts["TitleLabel"].exists)
        XCTAssertTrue(app.staticTexts["LanguageLabel"].exists)
        XCTAssertTrue(app.staticTexts["StargazersCountLabel"].exists)
        XCTAssertTrue(app.staticTexts["WachersCountLabel"].exists)
        XCTAssertTrue(app.staticTexts["ForksCountLabel"].exists)
        XCTAssertTrue(app.staticTexts["OpenIssuesCountLabel"].exists)
    }
}
