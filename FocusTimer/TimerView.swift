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
            Text("\(pomodoroTimer.timeRemaining)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .animation(.easeInOut, value: pomodoroTimer.timeRemaining)
            Button("Start Timer") {
                pomodoroTimer.startTimer()
            }
        }
    }
}

//#Preview {
//    TimerView()
//}
