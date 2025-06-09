//
//  VideoRecordTests.swift
//  VideoRecordTests
//
//  Created by wpc on 9/6/2025.
//

import XCTest
@testable import VideoRecord

final class VideoRecordTests: XCTestCase {

    var mockView: MockVideoRecordView!
    var mockModel: MockVideoRecordModel!
    var presenter: VideoRecordPresenterProtocol!

    override func setUp() {
        super.setUp()
        mockView = MockVideoRecordView()
        mockModel = MockVideoRecordModel()
        presenter = VideoRecordPresenter(view: mockView, model: mockModel)
    }

    override func tearDown() {
        mockView = nil
        mockModel = nil
        presenter = nil
    }

    func testHandleStartRecordingWithGrantedPermission() {
        mockModel.cameraPermissionGranted = true
        mockModel.microphonePermissionGranted = true

        presenter.handleStartRecordMessage()

        XCTAssertTrue(mockModel.checkCameraPermissionCalled)
        XCTAssertTrue(mockModel.checkMicrophonePermissionCalled)
    }

    func testHandleStartRecordingWithDeniedPermission() {
        mockModel.cameraPermissionGranted = false

        presenter.handleStartRecordMessage()

        XCTAssertTrue(mockModel.checkCameraPermissionCalled)
        XCTAssertTrue(mockModel.requestCameraPermissionCalled)
    }

    func testHandleVideoRecorded() {
        let testURL = URL(fileURLWithPath: "test.mp4")
        presenter.handleVideoReocrd(url: testURL)
        XCTAssertTrue(mockView.playVideoCalled)
        XCTAssertEqual(mockView.playedVideoURL, testURL)
    }

    func testHandleRecordingFailed() {
        let testError = NSError(domain: "Test", code: 0, userInfo: nil)
        presenter.handleRecordFailure(error: testError)
        XCTAssertTrue(mockView.showErrorCalled)
    }
}

// MARK: Mock Classes

class MockVideoRecordView: VideoRecordViewProtocol {

    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showErrorCalled = false
    var showTipsCalled = false
    var showPermissionDeniedAlertCalled = false
    var presentCameraCalled = false
    var playVideoCalled = false
    var playedVideoURL: URL?

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }

    func showError(message: String) {
        showErrorCalled = true
    }

    func showTips(message: String) {
        showTipsCalled = true
    }

    func showPermissionDeniedAlert() {
        showPermissionDeniedAlertCalled = true
    }

    func presentCamera() {
        presentCameraCalled = true
    }

    func playVideo(with url: URL) {
        playVideoCalled = true
        playedVideoURL = url
    }
}

class MockVideoRecordModel: VideoRecordModelProtocol {

    var cameraPermissionGranted = false
    var microphonePermissionGranted = false
    var checkCameraPermissionCalled = false
    var checkMicrophonePermissionCalled = false
    var requestCameraPermissionCalled = false

    func checkCameraPermission(completion: @escaping (Bool) -> ()) {
        checkCameraPermissionCalled = true
        completion(cameraPermissionGranted)
    }

    func checkMicrophonePermission(completion: @escaping (Bool) -> ()) {
        checkMicrophonePermissionCalled = true
        completion(microphonePermissionGranted)
    }

    func requestCameraPermission(completion: @escaping (Bool) -> ()) {
        requestCameraPermissionCalled = true
        completion(cameraPermissionGranted)
    }
}
