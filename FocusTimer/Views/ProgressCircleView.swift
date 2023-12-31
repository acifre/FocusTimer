//
//  ProgressCircleView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//

import SwiftUI

struct ProgressCircleView: View {
    @EnvironmentObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Grey background circle
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: pomodoroTimer.isTimerRunning ? geometry.size.width * 0.08 : geometry.size.width * 0.06)
                    .shadow(radius: 1)
                    .animation(.easeOut(duration: 0.5), value: pomodoroTimer.isTimerRunning)

                // Blue progress circle
                Circle()
                    .trim(from: 0.0, to: min(pomodoroTimer.progress, 1.0))
                    .stroke(pomodoroTimer.currentColor, style: StrokeStyle(lineWidth: pomodoroTimer.isTimerRunning ? geometry.size.width * 0.08 : geometry.size.width * 0.06, lineCap: .butt, lineJoin: .miter))
                    .rotationEffect(Angle(degrees: -90))
                    .shadow(radius: 2)
                    .animation(.easeOut(duration: 0.5), value: pomodoroTimer.isTimerRunning)

            }
            .animation(.easeOut(duration: 0.5), value: pomodoroTimer.progress)
        }
    }
}


//#Preview {
//    ProgressCircleView()
//}
