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
            .fontWeight(.bold)
    }
}


//#Preview {
//    TimerDisplayView(pomodoroTimer: PomodoroTimer())
//}
