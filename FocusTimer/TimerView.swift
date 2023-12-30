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
        GeometryReader { geometry in
            VStack {
                Spacer()

                VStack {
                    ZStack {
                        ProgressCircleView(progress: progress, isTimerRunning: $pomodoroTimer.isTimerRunning)
                            .frame(width: min(geometry.size.width, geometry.size.height) * 0.8, height: min(geometry.size.width, geometry.size.height) * 0.8)

                        VStack {
                            Text(pomodoroTimer.timeFormatted())
                                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.15)) // Dynamic font size
                            .fontWeight(.bold)
                            Text("Next Up: \(nextUpText)")
                                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.05)) // Dynamic font size
//                                .padding(.vertical, geometry.size.width * 0.02)
                        }
                    }
                        .padding(.vertical, geometry.size.width * 0.05)

                    // Pomodoro Session Indicators
                    HStack(spacing: geometry.size.width * 0.02) {
                        ForEach(0..<4, id: \.self) { index in
                            Circle()
                                .fill(index < pomodoroTimer.completedPomodoros ? Color.blue : Color.gray)
                                .frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
                        }
                    }
                        .padding(.vertical, geometry.size.width * 0.02)
                }
                    .frame(maxWidth: .infinity) // Ensures the content takes the full available width

                VStack {
                    // Control Buttons with Grey Background
                    HStack(spacing: geometry.size.width * 0.04) {
                        Button(action: { pomodoroTimer.rewindToPreviousSession() }) {
                            Image(systemName: "backward.fill")
                        }
                            .buttonStyle(DynamicButtonStyle(geometry: geometry))

                        // Toggle Start/Pause button
                        Button(action: {
                            pomodoroTimer.toggleTimer()
                        }) {
                            Image(systemName: pomodoroTimer.isTimerRunning ? "pause.fill" : "play.fill")
                        }
                            .buttonStyle(DynamicButtonStyle(geometry: geometry))
                            .font(.system(size: geometry.size.width * 0.07)) // Dynamic font size for the icon

                        Button(action: { pomodoroTimer.skipToNextSession() }) {
                            Image(systemName: "forward.fill")
                        }
                            .buttonStyle(DynamicButtonStyle(geometry: geometry))
                    }
                    .font(.system(size: geometry.size.width * 0.05))
                    .padding(.horizontal, geometry.size.width * 0.04) // Dynamic horizontal padding
//                    .padding(.vertical, geometry.size.height * 0.02) // Dynamic vertical padding

                    // Reset Button
                    Button("Reset") {
                        pomodoroTimer.resetSequence()
                    }
                    .font(.system(size: geometry.size.width * 0.04))
                        .foregroundColor(Color.red)
                        .padding()
                }
                Spacer()
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures the GeometryReader takes the full available space
    }

    private var nextUpText: String {
        switch pomodoroTimer.sessionType {
        case .pomodoro:
            return pomodoroTimer.completedPomodoros >= 3 ? "Finish" : "Break"
        case .shortBreak:
            return "Focus"
        case .longBreak:
            return "Another round?"
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

// Dynamic Button Style
struct DynamicButtonStyle: ButtonStyle {
    var geometry: GeometryProxy

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(geometry.size.width * 0.045)
            .background(Color.gray.opacity(0.2))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


//#Preview {
//    TimerView()
//}
