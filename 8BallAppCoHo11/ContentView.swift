//
//  ContentView.swift
//  8BallAppCoHo11
//
//  Created by Stephen Truitt on 10/7/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TiltViewModel()
    //not sure exactly how this works
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 24) {
            Text("Is Tilted?")
                .font(.largeTitle.bold())

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)

            } else if viewModel.hasReading {
                Image(systemName: "iphone")
                    .font(.system(size: 80))
                    .rotationEffect(.degrees(viewModel.rollDegrees))

                Text(viewModel.isTilted ? "Tilted!" : "Level")
                    .font(.title.bold())
                    .foregroundStyle(
                        viewModel.isTilted ? .orange : .green
                    )

                Text("Tilt: \(viewModel.tiltAmount, specifier: "%.1f")°")
                    .font(.title2)
                    .monospacedDigit()

                Text("Roll: \(viewModel.rollDegrees, specifier: "%.1f")°")

                Text("Pitch: \(viewModel.pitchDegrees, specifier: "%.1f")°")

            } else {
                ProgressView("Waiting for motion…")
            }
            
            if viewModel.isDemoMode {
                VStack(spacing: 12) {
                    Text("Demo Mode — Simulated Motion")
                        .font(.headline)

                    Text("Tilt left / right")
                    Slider(
                        value: $viewModel.roll,
                        in: (-Double.pi / 4)...(Double.pi / 4)
                    )

                    Text("Tilt forward / backward")
                    Slider(
                        value: $viewModel.pitch,
                        in: (-Double.pi / 4)...(Double.pi / 4)
                    )

                    Button("Reset to Level") {
                        viewModel.roll = 0
                        viewModel.pitch = 0
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            Text("Lay your phone face-up and flat, then tilt it.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .onAppear {
            viewModel.startMotionUpdates()
        }
        .onDisappear {
            viewModel.stopMotionUpdates()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                viewModel.startMotionUpdates()
            } else {
                viewModel.stopMotionUpdates()
            }
        }
    }
}

#Preview {
    ContentView()
}
