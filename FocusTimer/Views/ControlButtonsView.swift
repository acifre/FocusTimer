//
//  ControlButtonsView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/30/23.
//

import SwiftUI

struct ControlButtonsView: View {
    @EnvironmentObject var pomodoroTimer: PomodoroTimer
    @Binding var intent: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack(spacing: 15) {
            // Your buttons here (Start/Pause, Skip, Reset, etc.)
            // Example:
            Button(action: {
                pomodoroTimer.resetSequence()
                intent = ""
                isEditing = true

            }) {
                Image(systemName: "stop.fill")
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
                .font(pomodoroTimer.isTimerRunning ? .largeTitle : .title2)
                .animation(.easeInOut(duration: 0.5), value: pomodoroTimer.isTimerRunning)


            Button(action: { pomodoroTimer.skipToNextSession() }) {
                Image(systemName: "forward.end.fill")
            }
                .buttonStyle(ControlButtonStyle())
        }
        .font(.title3)
        .animation(.easeInOut(duration: 0.5), value: pomodoroTimer.isTimerRunning)
    }
}

// Button Style for Control Buttons
struct ControlButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

//#Preview {
//    ControlButtonsView()
//}
