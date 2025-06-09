//
//  ViewController.swift
//  VideoRecord
//
//  Created by wpc on 9/6/2025.
//

import UIKit
import WebKit

protocol VideoRecordViewProtocol: AnyObject {
    
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func showTips(message: String)
    func showPermissionDeniedAlert()
    func presentCamera()
    func playVideo(with url: URL)
}

class ViewController: UIViewController {
    
    private var presenter: VideoRecordPresenterProtocol!
    private var router: VideoRecordRouterProtocol!
    
    // subviews
    private var webView: WKWebView!
    private var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let model = VideoRecordModel()
        presenter = VideoRecordPresenter(view: self, model: model)
        router = VideoRecordRouter(viewController: self)
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        // init webview
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "startRecording")

        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)

        guard let htmlPath = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "Web") else {
            print("Log error: html path is invalid")
            return
        }
        let htmlURL = URL(filePath: htmlPath)
        webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL)

        // init indicator
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeLeft, .landscapeRight]
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.webView.frame = CGRect(origin: .zero, size: size)
        } completion: { _ in }
    }
}

// MARK: VideoRecordViewProtocol
extension ViewController: VideoRecordViewProtocol {
    
    func showLoading() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func showError(message: String) {
        let js = "showError('\(message)')"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func showTips(message: String) {
        let js = "showTips('\(message)')"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func playVideo(with url: URL) {
        let videoPath = url.absoluteString
        let js = "playVideo('\(videoPath)')"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func presentCamera() {
        router.presentCamera(delegate: self)
    }
    
    func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Camera Access Needed",
            message: "please allow camera access in Settings to record video",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { [weak self] _ in
            self?.router.openAppSettings()
        }))
        present(alert, animated: true)
    }
}

// MARK: WKNavigationDelegate
extension ViewController: WKNavigationDelegate {
    
    // webview is start loading
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    
    // webview has already loaded
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    // webview loaded fail
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        loadingIndicator.stopAnimating()
    }
    
    // webview loaded fail
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        loadingIndicator.stopAnimating()
    }
}

// MARK: UIImagePickerControllerDelegate && UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let videoURL = info[.mediaURL] as? URL else {
            presenter.handleRecordFailure(error: NSError(domain: "VideoRecording", code: -1, userInfo: nil))
            return
        }
        self.presenter.handleVideoReocrd(url: videoURL)
    }
}

// MARK: WKScriptMessageHandler
extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "startRecording" {
            presenter.handleStartRecordMessage()
        }
    }
}

