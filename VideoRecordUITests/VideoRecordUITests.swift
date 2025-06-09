//
//  VideoRecordUITests.swift
//  VideoRecordUITests
//
//  Created by wpc on 9/6/2025.
//

import XCTest

final class VideoRecordUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testWebViewLoads() {
        app.launchArguments.append("--testWebViewLoads")
        app.launch()
        
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
    }
    
    func testStartRecordButton() {
        app.launchArguments.append("--testStartRecordButton")
        app.launch()
        
        let webView = app.webViews.firstMatch
        let startRecordButton = webView.buttons["startRecording"]
        
        if startRecordButton.exists {
            startRecordButton.tap()
            let permissionAlert = app.alerts["Camera Access Needed"]
            let cameraView = app.otherElements["CameraView"]
            
            XCTAssertTrue(permissionAlert.exists || cameraView.exists)
        }
    }
    
    func testVideoPlaybackAfterRecording() {
        app.launchArguments.append("--testVideoPlaybackAfterRecording")
        app.launch()
        
        let webView = app.webViews.firstMatch
        let startRecordingButton = webView.buttons["startRecording"]
        
        if startRecordingButton.exists {
            startRecordingButton.tap()
            
            let videoPlayer = webView.otherElements["videoPlayer"]
            XCTAssertTrue(videoPlayer.waitForExistence(timeout: 5))
        }
    }
    
    func testErrorHandling() {
        app.launchArguments.append("--testErrorHandling")
        app.launch()
        
        let webView = app.webViews.firstMatch
        let startRecordingButton = webView.buttons["startRecording"]
        
        if startRecordingButton.exists {
            startRecordingButton.tap()
            
            let errorMessage = webView.staticTexts["Video recording failed"]
            XCTAssertTrue(errorMessage.waitForExistence(timeout: 5))
        }
    }
}
