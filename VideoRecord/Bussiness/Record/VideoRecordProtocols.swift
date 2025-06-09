//
//  VideoRecordProtocols.swift
//  VideoRecord
//
//  Created by wpc on 9/6/2025.
//

import Foundation

// MARK: view protocol
protocol VideoRecordViewProtocol: AnyObject {
    
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func showTips(message: String)
    func showPermissionDeniedAlert()
    func presentCamera()
    func playVideo(with url: URL)
}

// MARK: model protocol
protocol VideoRecordModelProtocol {
    
    func checkCameraPermission(completion: @escaping (Bool) -> ())
    func checkMicrophonePermission(completion: @escaping (Bool) -> ())
    func requestCameraPermission(completion: @escaping (Bool) -> ())
}

// MARK: presenter protocol
protocol VideoRecordPresenterProtocol {
    
    func handleStartRecordMessage()
    func handleVideoReocrd(url: URL)
    func handleRecordFailure(error: Error)
}
