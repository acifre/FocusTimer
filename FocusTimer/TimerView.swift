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
            Text(pomodoroTimer.timeFormatted())
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .animation(.easeInOut, value: pomodoroTimer.timeRemaining)

            Text(currentSessionText())
                .font(.headline)

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
}



//#Preview {
//    TimerView()
//}
