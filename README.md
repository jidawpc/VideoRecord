# Mendix Mobile Developer Assessment - VideoRecord

This is a native iOS demo app showcasing communication between a web app embedded in a `WKWebView` and native iOS functionality. The user clicks a "Record Video" button in the web app, which triggers native video recording. Once recording is complete, the video is played back within the web page.


## Features

- WebView with HTML/CSS/JS-based interface
- Native video recording via `UIImagePickerController`
- JavaScript → Swift communication (`WKScriptMessageHandler`)
- Swift → JavaScript callback (`evaluateJavaScript`)
- MVP(R) architecture 
- With unit tests and UI test support
- Support portraint, landscapde oritentions
- Microphone & camera permission detection with user-friendly alerts
- Camera access is a must for recording, if denied, will friendly bounce out persmission setting alert


## How to Run

1. Open the Xcode project and run on a **real device** (camera not available in simulator).
2. Web files are bundled in app (can also host on local server).
3. Tap the "Record Video" button and follow prompts.


## Web App URL
The web app is loaded from a local file URL inside the app bundle, path is:
**VideoRecrod/Web/index.html**
No external setup is required.



