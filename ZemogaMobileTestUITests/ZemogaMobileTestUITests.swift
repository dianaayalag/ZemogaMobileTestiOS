//
//  ZemogaMobileTestUITests.swift
//  ZemogaMobileTestUITests
//
//  Created by Diana Ayala on 5/18/22.
//

import XCTest

class ZemogaMobileTestUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    // MARK: MainView
    
    func testTrashButton() throws {
        // Create and launch app
        let app = XCUIApplication()
        app.launch()
        // Check if navigation bar exists
        let navigationBar = app.navigationBars["Posts"]
        XCTAssertTrue(navigationBar.exists, "Navigation bar doesn't exist")
        // Check if trash button exits
        let trashButton = navigationBar.buttons["trash"]
        XCTAssertTrue(trashButton.exists, "Trash button doesn't exist")
        // Tapping trash button should open alert
        trashButton.tap()
        // Check if alert exists
        let deleteAlert = app.alerts["Delete"]
        XCTAssertTrue(deleteAlert.exists, "Delete alert doesn't exist (1st time)")
        // Check if cancel button is there, then tap
        let cancelButton = deleteAlert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button doesn't exist")
        cancelButton.tap()
        // Since we cancelled the action, the alert should not be there
        XCTAssertFalse(deleteAlert.exists)
        // Now let's check the delete action of the alert, so we should tap the trash button again
        trashButton.tap()
        // check if the delete alert is open
        XCTAssertTrue(deleteAlert.exists, "Delete alert doesn't exist (2nd time)")
        // Check if delete button is there, then tap
        let deleteButton = deleteAlert.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists, "Delete button doesn't exist (2nd time)")
        deleteButton.tap()
        // Alert of successfully deleted or failed, should display
        let deletedAlert = app.alerts["Deleted"]
        // We should wait for the posts to be deleted
        XCTAssertTrue(deletedAlert.waitForExistence(timeout: 2), "Deleted alert doesn't exist")
        // Check if ok button is there, then tap
        let okButton = deletedAlert.buttons["Ok"]
        XCTAssertTrue(okButton.exists, "Ok button doesn't exist")
        okButton.tap()
        // Since we deleted everything, the table should be empty
        let emptyTable = app.tables["Empty list"]
        XCTAssertTrue(emptyTable.exists, "Empty table isn't there")
        // Terminate app
        app.terminate()
    }
    
    func testFavoritesSegmentedControl() {
        // Create and launch app
        let app = XCUIApplication()
        app.launch()
        // Check if table exists
        let table = app.tables.firstMatch
        XCTAssertTrue(table.exists, "Table doesn't exist")
        // We should have at least one favorite element
        let favoriteCell = table.cells.containing(.staticText, identifier:"sunt aut facere repellat provident occaecati excepturi optio reprehenderit").firstMatch
        XCTAssertTrue(favoriteCell.exists, "Cell to favorite doesn't exist")
        // Let's check if the cell has a favorite button and tap it
        let favoriteButton = favoriteCell.buttons["favorite"]
        XCTAssertTrue(favoriteButton.exists, "Favorite button doesn't exist")
        // Tap button to make it favorite
        favoriteButton.tap()
        // Check if there's 1 segmented control
        let segmentedControl = app.segmentedControls.firstMatch
        XCTAssertTrue(segmentedControl.exists, "Segmented control doesn't exist")
        // Check if the segmented control has a favorites filter button and tap it
        let favoritesFilterButton = segmentedControl.buttons["Favorites"]
        XCTAssertTrue(favoritesFilterButton.exists, "Segmented control exists, but doesn't have a Favorites button")
        favoritesFilterButton.tap()
        // Check if table was filtered correctly and we have our favorite cell, this test also verifies if the favorite button of the cell works
        XCTAssertTrue(favoriteCell.exists, "Favorite cell doesn't exist")
        // Terminate app
        app.terminate()
    }
    
    func testSwipeToDelete_deleteWithButton() {
        // Create and launch app
        let app = XCUIApplication()
        app.launch()
        // Check if table exists
        let table = app.tables.firstMatch
        XCTAssertTrue(table.exists, "Table doesn't exist")
        // Choose our cell to delete and check if exists
        let cellToDelete = table/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"qui est esse")/*[[".cells.containing(.button, identifier:\"Delete\")",".cells.containing(.staticText, identifier:\"qui est esse\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        XCTAssertTrue(cellToDelete.exists, "Cell to delete doesn't exist")
        // Swipe left to delete
        cellToDelete.swipeLeft()
        // Check if button appeared
        let deleteButton = cellToDelete.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists, "Delete button doesn't exist")
        // Tap delete button
        deleteButton.tap()
        // Check if the cell was deleted
        XCTAssertFalse(cellToDelete.exists, "Cell to delete exists after deletion")
        // Terminate app
        app.terminate()
    }
    
    func testSwipeToDelete_deleteWithGesture() {
        // Create and launch app
        let app = XCUIApplication()
        app.launch()
        // Check if table exists
        let table = app.tables.firstMatch
        XCTAssertTrue(table.exists, "Table doesn't exist")
        // Choose our cell to delete and check if exists
        let cellToDelete = table/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"qui est esse")/*[[".cells.containing(.button, identifier:\"Delete\")",".cells.containing(.staticText, identifier:\"qui est esse\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        XCTAssertTrue(cellToDelete.exists, "Cell to delete doesn't exist")
        // Drag left to perform automatic delete
        let rightOffset = CGVector(dx: 0.95, dy: 0.5)
        let leftOffset = CGVector(dx: 0.05, dy: 0.5)
        let cellFarRightCoordinate = cellToDelete.coordinate(withNormalizedOffset: rightOffset)
        let cellFarLeftCoordinate = cellToDelete.coordinate(withNormalizedOffset: leftOffset)
        cellFarRightCoordinate.press(forDuration: 0.1, thenDragTo: cellFarLeftCoordinate)
        // Check if the cell was deleted
        XCTAssertFalse(cellToDelete.exists, "Cell to delete exists after deletion")
        // Terminate app
        app.terminate()
    }
    
    // MARK: DetailView
    
    func testDetailShowsRightInfo() {
        // Create and launch app
        let app = XCUIApplication()
        app.launch()
        // Check if table exists
        let table = app.tables.firstMatch
        XCTAssertTrue(table.exists, "Table doesn't exist")
        // Choose our cell to check it's detail info
        let cellToTap = table/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"qui est esse")/*[[".cells.containing(.button, identifier:\"Delete\")",".cells.containing(.staticText, identifier:\"qui est esse\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        XCTAssertTrue(cellToTap.exists, "Cell to tap doesn't exist")
        cellToTap.tap()
        // Check if we have the right info displayed
        let titleLabel = app.staticTexts["qui est esse"]
        XCTAssertTrue(titleLabel.exists, "Title is not showing")
        // Use NSPredicate workaround to partially match the text
        var textToMatch = "est rerum tempore vitae"
        var predicate = NSPredicate(format: "label CONTAINS '\(textToMatch)'")
        let bodyLabel = app.staticTexts.matching(predicate).firstMatch
        XCTAssertTrue(bodyLabel.exists, "Body is not showing")
        let userNameLabel = app.staticTexts["Leanne Graham"]
        XCTAssertTrue(userNameLabel.waitForExistence(timeout: 2), "User-Name is not showing")
        let userEmailLabel = app.staticTexts["Sincere@april.biz"]
        XCTAssertTrue(userEmailLabel.waitForExistence(timeout: 2), "User-Email is not showing")
        let userPhoneLabel = app.staticTexts["1-770-736-8031 x56442"]
        XCTAssertTrue(userPhoneLabel.waitForExistence(timeout: 2), "User-Phone is not showing")
        let userWebsiteLabel = app.staticTexts["hildegard.org"]
        XCTAssertTrue(userWebsiteLabel.waitForExistence(timeout: 2), "User-Website is not showing")
        textToMatch = "doloribus at sed quis culpa deserunt consectetur qui praesentium"
        predicate = NSPredicate(format: "label CONTAINS '\(textToMatch)'")
        let firstComment = app.tables.cells.containing(predicate).firstMatch
        XCTAssertTrue(firstComment.waitForExistence(timeout: 2), "First comment is not showing")
        // Terminate app
        app.terminate()
    }
}
