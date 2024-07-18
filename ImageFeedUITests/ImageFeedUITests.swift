//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Вадим on 17.07.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("<Ваш e-mail>") // "<Ваш e-mail>"
        webView.swipeUp()
        
        // Мой способ
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        UIPasteboard.general.string = "<Ваш пароль>" // "<Ваш пароль>"
        passwordTextField.doubleTap()
        app.menuItems["Paste"].tap()
        
        // Способ Артёма
//        let passwordTextField = webView.descendants(matching: .secureTextField).element
//        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
//        passwordTextField.tap()
//        passwordTextField.typeText("<Ваш пароль>")
//        sleep(1)
//        webView.swipeUp()
//        app.toolbars.buttons["Done"].tap()
//        sleep(1)
        
        // Спасоб Эльдара
//        let passwordTextField = webView.descendants(matching: .secureTextField).element
//        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
//        passwordTextField.tap()
//        sleep(3)
//        XCUIApplication().toolbars.buttons["Done"].tap()
//        passwordTextField.tap()
//        passwordTextField.typeText("<Ваш пароль>")
//        sleep(3)
//        XCUIApplication().toolbars.buttons["Done"].tap()
        
        webView.swipeUp()
        webView.buttons["Login"].tap()
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["like button off"].tap()
        cellToLike.buttons["like button on"].tap()
        sleep(2)
        cellToLike.tap()
        sleep(2)
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.staticTexts["Ваш Name Lastname"].exists) // Ваш Name Lastname
        XCTAssertTrue(app.staticTexts["ваш @username"].exists) // ваш @username
        app.buttons["logout button"].tap()
        app.alerts["Выход из аккаунта"].scrollViews.otherElements.buttons["Подтвердить"].tap()
    }
}
