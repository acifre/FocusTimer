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
        ZStack {
            ProgressCircleView(progress: progress)
                .frame(width: 200, height: 200)

            VStack {
                Text(pomodoroTimer.timeFormatted())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                HStack {
                    Button("Start") {
                        pomodoroTimer.startTimer()
                    }
                    Button("Pause") {
                        pomodoroTimer.pauseTimer()
                    }
                    Button("Reset") {
                        pomodoroTimer.resetTimer()
                    }
                    Button("Skip") {
                        pomodoroTimer.skipToNextSession()
                    }
                }
                    .padding()
            }
        }
    }

    private func currentSessionText() -> String {
        switch pomodoroTimer.sessionType {
        case .pomodoro:
            return "Pomodoro Session"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }

    private var progress: CGFloat {
        let totalDuration = CGFloat(pomodoroTimer.duration(for: pomodoroTimer.sessionType))
        let remaining = CGFloat(pomodoroTimer.timeRemaining)
        return 1.0 - (remaining / totalDuration)
    }
}



//#Preview {
//    TimerView()
//}
