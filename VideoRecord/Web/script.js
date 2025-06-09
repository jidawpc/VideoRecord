function startRecording() {
    if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.startRecording) {
        window.webkit.messageHandlers.startRecording.postMessage(null);
    } else {
        showError("Recording not supported.");
    }
}

function playVideo(url) {
    const video = document.getElementById("videoPlayer");
    video.src = url;
    video.addEventListener("canplay", function handler() {
        video.removeEventListener("canplay", handler);
        video.play();
    })
    video.load();
}

function showError(message) {
    document.getElementById("error").innerText = message;
}

function showTips(message) {
    document.getElementById("tips").innerText = message;
}
