//
//  SequenceProgressView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//

import SwiftUI

struct SequenceProgressView: View {
    @ObservedObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        VStack {
            Text("Current Session: \(sessionName(for: pomodoroTimer.sessionType))")
                .font(.headline)
                .padding()

            HStack {
                ForEach(0..<4, id: \.self) { index in
                    ProgressCircleView(progress: progressForCircle(at: index))
                        .frame(width: 20, height: 20)
                }
            }
                .padding()
        }
    }

    private func sessionName(for sessionType: PomodoroTimer.SessionType) -> String {
        switch sessionType {
        case .pomodoro:
            return "Pomodoro"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }

    private func progressForCircle(at index: Int) -> CGFloat {
        if index < pomodoroTimer.completedPomodoros {
            return 1.0 // Full circle for completed Pomodoros
        } else if index == pomodoroTimer.completedPomodoros && pomodoroTimer.sessionType == .pomodoro {
            let totalDuration = CGFloat(pomodoroTimer.duration(for: .pomodoro))
            let remaining = CGFloat(pomodoroTimer.timeRemaining)
            return 1.0 - (remaining / totalDuration) // Partial circle for current Pomodoro
        } else {
            return 0.0 // Empty circle for future Pomodoros
        }
    }
}


//#Preview {
//    SequenceProgressView()
//}
