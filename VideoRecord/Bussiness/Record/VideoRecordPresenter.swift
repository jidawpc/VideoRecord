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
