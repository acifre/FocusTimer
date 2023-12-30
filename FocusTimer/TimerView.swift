//
//  TimerView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        VStack {
            // Timer and Progress Circle
            ZStack {
                ProgressCircleView(progress: progress, isTimerRunning: $pomodoroTimer.isTimerRunning)
                    .frame(width: 250, height: 250)

                VStack {
                    Text(pomodoroTimer.timeFormatted())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Next Up: \(nextUpText)")
                        .font(.headline)
                        .padding(.vertical, 5)
                }
            }
                .padding()

            // Pomodoro Session Indicators
            HStack(spacing: 5) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < pomodoroTimer.completedPomodoros ? Color.blue : Color.gray)
                        .frame(width: 15, height: 15)
                }
            }
                .padding(.vertical)

            // Control Buttons with Grey Background
            HStack(spacing: 20) {
                Button(action: { pomodoroTimer.rewindToPreviousSession() }) {
                    Image(systemName: "backward.fill")
                }
                    .buttonStyle(ControlButtonStyle())

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
                .font(.title)
                .padding()
            // Reset Button
            Button("Reset") {
                pomodoroTimer.resetSequence()
            }
                .foregroundColor(Color.red)
                .padding()
        }
    }
    private var nextUpText: String {
        switch pomodoroTimer.sessionType {
        case .pomodoro:
            return pomodoroTimer.completedPomodoros >= 3 ? "Finish" : "Break"
        case .shortBreak, .longBreak:
            return "Focus"
        }
    }

    private var progress: CGFloat {
        let totalDuration = CGFloat(pomodoroTimer.duration(for: pomodoroTimer.sessionType))
        let remaining = CGFloat(pomodoroTimer.timeRemaining)
        return 1.0 - (remaining / totalDuration)
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
//    TimerView()
//}
