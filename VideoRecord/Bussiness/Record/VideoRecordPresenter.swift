//
//  VideoRecordPresenter.swift
//  VideoRecord
//
//  Created by wpc on 9/6/2025.
//

import Foundation

class VideoRecordPresenter: VideoRecordPresenterProtocol {
    
    weak var view: VideoRecordViewProtocol?
    let model: VideoRecordModelProtocol
    
    init(view: VideoRecordViewProtocol?, model: VideoRecordModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func handleStartRecordMessage() {
        // Camera is a must for video record, if it is diabled, use error tips(red color) to give tips to user, and when click it again, bounce out alert to jump to Settings
        model.checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.checkMicrophoneAndPresentCamera()
            } else {
                self.model.requestCameraPermission { granted in
                    DispatchQueue.main.async {
                        if granted {
                            self.checkMicrophoneAndPresentCamera()
                        } else {
                            self.view?.showPermissionDeniedAlert()
                            self.view?.showError(message: "Camera access denied")
                        }
                    }
                }
            }
        }
    }
    
    func handleVideoReocrd(url: URL) {
        view?.playVideo(with: url)
    }
    
    func handleRecordFailure(error: any Error) {
        view?.showError(message: "Video record failed")
    }
}

extension VideoRecordPresenter {
    
    // Microphone is not a must, but if denied, the video would be muted, so use tips to tell user where to enable it if it is disabled.
    private func checkMicrophoneAndPresentCamera() {
        model.checkMicrophonePermission { [weak self] granted in
            DispatchQueue.main.async {
                if !granted {
                    self?.view?.showTips(message: "Micro auth denied, record would be muted, you can go to Settings to open it")
                }
                self?.view?.presentCamera()
            }
        }
    }
}
