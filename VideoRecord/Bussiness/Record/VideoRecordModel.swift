//
//  VideoRecordModel.swift
//  VideoRecord
//
//  Created by wpc on 9/6/2025.
//

import Foundation
import AVFoundation

protocol VideoRecordModelProtocol {
    
    func checkCameraPermission(completion: @escaping (Bool) -> ())
    func checkMicrophonePermission(completion: @escaping (Bool) -> ())
    func requestCameraPermission(completion: @escaping (Bool) -> ())
}

class VideoRecordModel: VideoRecordModelProtocol {
    
    func checkCameraPermission(completion: @escaping (Bool) -> ()) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        completion(status == .authorized)
    }
    
    func checkMicrophonePermission(completion: @escaping (Bool) -> ()) {
        if #available(iOS 17.0, *) {
            let status = AVAudioApplication.shared.recordPermission
            completion(status == .granted)
        } else {
            let status = AVAudioSession.sharedInstance().recordPermission
            completion(status == .granted)
        }
    }
    
    func requestCameraPermission(completion: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}
