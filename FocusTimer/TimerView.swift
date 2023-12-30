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
                ProgressCircleView(progress: progress)
                    .frame(width: 200, height: 200)
                Text(pomodoroTimer.timeFormatted())
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }

            // Pomodoro Session Indicators
            HStack(spacing: 5) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < pomodoroTimer.completedPomodoros ? Color.blue : Color.gray)
                        .frame(width: 15, height: 15)
                }
            }
                .padding(.vertical)

            // Control Buttons: Rewind, Start/Pause, Skip
            HStack(spacing: 20) {
                Button(action: {
                    pomodoroTimer.rewindToPreviousSession()
                }) {
                    Image(systemName: "backward.fill")
                }

                Button(action: {
                    if pomodoroTimer.timer == nil {
                        pomodoroTimer.startTimer()
                    } else {
                        pomodoroTimer.pauseTimer()
                    }
                }) {
                    Image(systemName: pomodoroTimer.timer == nil ? "play.fill" : "pause.fill")
                }

                Button(action: {
                    pomodoroTimer.skipToNextSession()
                }) {
                    Image(systemName: "forward.fill")
                }
            }
                .font(.title)
                .padding()

            // Reset Button
            Button("Reset") {
                pomodoroTimer.resetTimer()
            }
                .padding()
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
