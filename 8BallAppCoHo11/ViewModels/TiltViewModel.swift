//
//  8BallView.swift
//  8BallAppCoHo11
//
//  Created by Stephen Truitt on 10/7/26.
//

import Foundation
import Combine
import CoreMotion

class TiltViewModel: ObservableObject {
    private let motionManager = CMMotionManager()

    @Published var roll: Double = 0.0
    @Published var pitch: Double = 0.0
    @Published var hasReading = false
    @Published var errorMessage = ""
    @Published var isDemoMode = false

    var rollDegrees: Double {
        roll * 180 / .pi
    }

    var pitchDegrees: Double {
        pitch * 180 / .pi
    }

    var tiltAmount: Double {
        max(abs(rollDegrees), abs(pitchDegrees))
    }

    var isTilted: Bool {
        tiltAmount > 5
    }

    func startMotionUpdates() {
        guard !motionManager.isDeviceMotionActive else {
            return
        }

        guard motionManager.isDeviceMotionAvailable else {
            isDemoMode = true
            errorMessage = ""
            hasReading = true
            return
        }

        isDemoMode = false

        errorMessage = ""
        hasReading = false
        motionManager.deviceMotionUpdateInterval = 0.1

        motionManager.startDeviceMotionUpdates(to: .main) {
            [weak self] data, error in

            guard let self = self else { return }

            if let error = error {
                self.errorMessage = error.localizedDescription
                self.hasReading = false
                self.motionManager.stopDeviceMotionUpdates()
                return
            }

            guard let data = data else { return }

            self.roll = data.attitude.roll
            self.pitch = data.attitude.pitch
            self.hasReading = true
        }
    }

    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
        hasReading = false
    }
}
