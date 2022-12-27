//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class iOSEngineerCodeCheckUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func test_search() {
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
        XCTAssertTrue(app.staticTexts["DescriptionLabel"].exists)
        XCTAssertTrue(app.staticTexts["StargazersCountLabel"].exists)
        XCTAssertTrue(app.staticTexts["WachersCountLabel"].exists)
        XCTAssertTrue(app.staticTexts["ForksCountLabel"].exists)
        XCTAssertTrue(app.staticTexts["OpenIssuesCountLabel"].exists)
    }
    
    func test_favorite() {
        let favoriteTabBarItem = app.tabBars.buttons["Bookmarks"]
        favoriteTabBarItem.tap()
        sleep(2)
        
        /// RxSwiftのバグでiOSEngineerCodeCheckがimportできないためRealmが初期化できないのでこのような対応
        /// https://github.com/ReactiveX/RxSwift/issues/2210
        if app.staticTexts["EmptyLabel"].exists {
            let searchTabBarItem = app.tabBars.buttons["Search"]
            searchTabBarItem.tap()
            sleep(2)
            
            let searchBar = app.searchFields.element
            searchBar.tap()
            searchBar.typeText("Swift")
            app.keyboards.buttons["Search"].tap()
            sleep(3)
            let searchTableView = app.tables.element
            let searchCell = searchTableView.cells.element(boundBy: 0)
            searchCell.tap()
            sleep(2)
            
            let favoriteButton = XCUIApplication().navigationBars["検索画面"].buttons["love"]
            favoriteButton.tap()
            
            favoriteTabBarItem.tap()
            sleep(2)
            
            let favoriteTableView = app.tables.element
            let favoriteCell = favoriteTableView.cells.element(boundBy: 0)
            favoriteCell.tap()
            sleep(2)
            
            XCTAssertTrue(app.staticTexts["TitleLabel"].exists)
        } else {
            let favoriteTableView = app.tables.element
            let favoriteCell = favoriteTableView.cells.element(boundBy: 0)
            favoriteCell.tap()
            sleep(2)
            
            let favoriteButton = XCUIApplication().navigationBars["お気に入り画面"].buttons["love"]
            favoriteButton.tap()
            favoriteButton.tap()
            XCTAssertTrue(app.staticTexts["TitleLabel"].exists)
        }
    }
}
