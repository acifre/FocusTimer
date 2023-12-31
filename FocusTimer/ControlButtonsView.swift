//
//  ControlButtonsView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/30/23.
//

import SwiftUI

struct ControlButtonsView: View {
    @EnvironmentObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        HStack(spacing: 20) {
            // Your buttons here (Start/Pause, Skip, Reset, etc.)
            // Example:
            Button(action: { pomodoroTimer.toggleTimer() }) {
                Image(systemName: pomodoroTimer.isTimerRunning ? "pause.fill" : "play.fill")
            }
                .buttonStyle(ControlButtonStyle())
            // Add other buttons similarly

            // Toggle Start/Pause button
            Button(action: {
                pomodoroTimer.toggleTimer()
            }) {
                Image(systemName: pomodoroTimer.isTimerRunning ? "pause.fill" : "play.fill")
            }
                .buttonStyle(ControlButtonStyle())


            Button(action: { pomodoroTimer.skipToNextSession() }) {
                Image(systemName: "forward.fill")
            }
                .buttonStyle(ControlButtonStyle())
        }
    }
}

// Button Style for Control Buttons
struct ControlButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray.opacity(0.2))
            .clipShape(Circle())
    }
}

//#Preview {
//    ControlButtonsView()
//}
