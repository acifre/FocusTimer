//
//  PomodoroTimer.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//

import Foundation

class PomodoroTimer: ObservableObject {
    @Published var timeRemaining: Int
    let totalTime: Int

    init(totalTime: Int) {
        self.totalTime = totalTime
        self.timeRemaining = totalTime
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                timer.invalidate()
            }
        }
    }

    func resetTimer() {
        self.timeRemaining = totalTime
    }
}
