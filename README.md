# Hand Tracking Test (iPhone)
Supports iPhone with iOS 17+ using the front camera for real-time hand pose detection.

<br>

## Project structure 
📂 HandTracking <br>
├── 📄 MyApp.swift                # App Entry Point (SwiftUI) <br>
├── 📄 HandTrackingView.swift     # Main UI (SwiftUI) <br>
├── 📄 CameraView.swift           # SwiftUI Wrapper for Camera <br>
├── 📄 CameraViewController.swift # Camera & Vision Processing (UIKit) <br>
├── 📂 Assets                     <br>
└── 📂 Supporting Files          <br>

<br>

### HandTrackingView.swift (Main UI)
- Draws the detected hand skeleton with lines and points.

### CameraView.swift (SwiftUI Wrapper for CameraViewController)
- Connects SwiftUI with CameraViewController using **UIViewControllerRepresentable**.
- Receives the hand tracking data from CameraViewController and binds it to SwiftUI.


### CameraViewController.swift (Handles Camera & Vision Processing)
- Uses **AVCaptureSession** to access the iPhone's front camera.
- Runs Vision's hand tracking model on live video frames.
  + Uses **VNDetectHumanHandPoseRequest** for real-time hand tracking
- Converts Vision hand point coordinates to SwiftUI coordinates.

<br>
<br>

## screen shots
| screenshot 1 | screenshot 2 |
|--------------|--------------|
| ![screenshot 1](https://github.com/user-attachments/assets/70a0ddb7-bdf5-45dc-9a92-7bcf01019b51) | ![screenshot 2](https://github.com/user-attachments/assets/1e054b7d-9bb1-4653-9e32-707dfdb561f7)|


<br>
<br>

## How to Build & Run
### Requirements
- Xcode 15+
- iPhone running iOS 17+
- Swift Playgrounds or Swift Package Manager (SwiftPM)

### Steps to Run on iPhone:
1. Open Xcode(or Swift Playground) and connect an iPhone

<br>
<br>


## Reference
- [apple documentation](https://developer.apple.com/documentation/vision/detecting-hand-poses-with-vision)
- [medium How To Use Vision Hand Pose in SwiftUI](https://medium.com/codex/how-to-use-vision-hand-pose-in-swiftui-a24b7a7e5721)
- [createwithswfit Detecting hand pose with the Vision framework](https://www.createwithswift.com/detecting-hand-pose-with-the-vision-framework/)
- shinwon's Melody

<br>
<br>

**Bless you 😀**
