//
//  VideoRecordRouter.swift
//  VideoRecord
//
//  Created by wpc on 9/6/2025.
//

import UIKit
import UniformTypeIdentifiers

protocol VideoRecordRouterProtocol {
    
    func presentCamera(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    func openAppSettings()
}

class VideoRecordRouter: VideoRecordRouterProtocol {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    // open camera
    func presentCamera(delegate: any UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [UTType.movie.identifier]
        picker.videoQuality = .typeMedium
        picker.delegate = delegate
        viewController?.present(picker, animated: true)
    }
    
    // jump to iphone Settings
    func openAppSettings() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettingsURL) {
            UIApplication.shared.open(appSettingsURL)
        }
    }
}
