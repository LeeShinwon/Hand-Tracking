//
//  HandTrackingView.swift
//  HandTracking
//
//  Created by 이신원 on 2/15/25.
//

import SwiftUI
import AVFoundation
import Vision

struct HandTrackingView: View {
    @State private var handPoints: [CGPoint] = []
    
    var body: some View {
        ZStack {
            CameraView(handPoints: $handPoints)
            linesView
            pointsView
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private var linesView: some View {
        Path { path in
            let fingerJoints = [
                [1, 2, 3, 4],       // Thumb joints (thumbCMC -> thumbMP -> thumbIP -> thumbTip)
                [5, 6, 7, 8],       // Index finger joints
                [9, 10, 11, 12],    // Middle finger joints
                [13, 14, 15, 16],   // Ring finger joints
                [17, 18, 19, 20]    // Little finger joints
            ]
            
            if let wristIndex = handPoints.firstIndex(where: { $0 == handPoints.first }) {
                for joints in fingerJoints {
                    guard joints.count > 1 else { continue }

                    // Connect wrist to the first joint of each finger
                    if joints[0] < handPoints.count {
                        let firstJoint = handPoints[joints[0]]
                        let wristPoint = handPoints[wristIndex]
                        path.move(to: wristPoint)
                        path.addLine(to: firstJoint)
                    }

                    // Connect the joints within each finger
                    for i in 0..<(joints.count - 1) {
                        if joints[i] < handPoints.count && joints[i + 1] < handPoints.count {
                            let startPoint = handPoints[joints[i]]
                            let endPoint = handPoints[joints[i + 1]]
                            path.move(to: startPoint)
                            path.addLine(to: endPoint)
                        }
                    }
                }
            }
        }
        .stroke(.white, lineWidth: 3)
    }
    
    private var pointsView: some View {
        // for ios 18 + under versions
        ForEach(handPoints.indices, id: \.self) { index in
            let point = handPoints[index]
            
            Circle()
                .fill(.orange)
                .frame(width: 15)
                .position(x: point.x, y: point.y)
        }
    }

}

#Preview {
    HandTrackingView()
}
