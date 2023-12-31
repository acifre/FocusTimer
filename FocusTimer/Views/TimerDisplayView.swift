//
//  TimerDisplayView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/30/23.
//

import SwiftUI

struct TimerDisplayView: View {
    @EnvironmentObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        Text(pomodoroTimer.timeFormatted())
            .font(.largeTitle)
            .scaleEffect(pomodoroTimer.isTimerRunning ? 1.5 : 1.0)
            .fontWeight(.bold)
            .animation(.easeInOut(duration: 0.5), value: pomodoroTimer.isTimerRunning)
    }

}


//#Preview {
//    TimerDisplayView(pomodoroTimer: PomodoroTimer())
//}
