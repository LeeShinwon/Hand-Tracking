//
//  CameraView.swift
//  HandTracking
//
//  Created by 이신원 on 2/15/25.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var handPoints: [CGPoint]

    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.onHandPointsDetected = { points in
            handPoints = points
        }
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}
