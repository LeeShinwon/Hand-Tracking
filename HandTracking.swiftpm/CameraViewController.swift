//
//  CameraViewController.swift
//  HandTracking
//
//  Created by 이신원 on 2/15/25.
//

import AVFoundation
import UIKit
import Vision

enum AppError: Error {
    case camera
    case vision
    
    var alertDescription: String {
        switch self {
        case .camera:
            return "Failed to access the camera. Please try again."
        case .vision:
            return "Hand tracking failed. Please try again."
        }
    }
}

class CameraViewController: UIViewController {
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    private var cameraFeedSession: AVCaptureSession?
    var onHandPointsDetected: (([CGPoint]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try setupAVSession()
        } catch let error as AppError {
            showErrorAlert(error)
        } catch {
            showErrorAlert(.camera)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }

    func setupAVSession() throws {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw AppError.camera
        }

        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw AppError.camera
        }

        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = .high

        guard session.canAddInput(deviceInput) else { throw AppError.camera }
        session.addInput(deviceInput)

        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw AppError.camera
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.bounds

        session.commitConfiguration()
        session.startRunning()
        cameraFeedSession = session
    }
    
    private func showErrorAlert(_ error: AppError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    nonisolated public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        var handPoints: [CGPoint] = []

        let handJoints: [VNHumanHandPoseObservation.JointName] = [
            .wrist, .thumbCMC, .thumbMP, .thumbIP, .thumbTip,
            .indexMCP, .indexPIP, .indexDIP, .indexTip,
            .middleMCP, .middlePIP, .middleDIP, .middleTip,
            .ringMCP, .ringPIP, .ringDIP, .ringTip,
            .littleMCP, .littlePIP, .littleDIP, .littleTip
        ]
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        
        let handPoseRequest = VNDetectHumanHandPoseRequest()
        handPoseRequest.maximumHandCount = 1

        do {
            try handler.perform([handPoseRequest])
            guard let observation = handPoseRequest.results?.first else { return }

            var visionHandPoints: [CGPoint] = []
            
            for joint in handJoints {
                if let recognizedPoint = try? observation.recognizedPoint(joint), recognizedPoint.confidence > 0.3 {
                    visionHandPoints.append(recognizedPoint.location)
                }
            }
            
            DispatchQueue.main.async {
                let convertedHandPoints = visionHandPoints.map { self.convertHandPoints($0) }
                self.onHandPointsDetected?(convertedHandPoints)
            }

        } catch {
            DispatchQueue.main.async {
                self.showErrorAlert(.vision)
            }
            print("Hand tracking failed: \(error)")
        }
    }
    
    // Convert Vision coordinate system to SwiftUI coordinate system
    @MainActor
    private func convertHandPoints(_ point: CGPoint) -> CGPoint {
        let screenSize = UIScreen.main.bounds.size
        return CGPoint(x: (1 - point.y) * screenSize.width, y: point.x * screenSize.height)
    }
}
