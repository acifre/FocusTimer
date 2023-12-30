//
//  PomodoroTimer.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//
import Foundation

class PomodoroTimer: ObservableObject {
    enum SessionType {
        case pomodoro
        case shortBreak
        case longBreak
    }

    @Published var timeRemaining: Int
    @Published var isTimerRunning = false
    @Published var completedPomodoros: Int

    var timer: Timer?
    var sessionType: SessionType

    init() {
        self.sessionType = .pomodoro
        self.completedPomodoros = 0
        self.timeRemaining = 25 * 60 // Directly initializing with Pomodoro duration
    }

    func toggleTimer() {
        if isTimerRunning {
            // Pause the timer
            timer?.invalidate()
            timer = nil
            isTimerRunning = false
        } else {
            // Start the timer
            timer?.invalidate() // Safeguard to invalidate any existing timer
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let strongSelf = self else { return }
                if strongSelf.timeRemaining > 0 {
                    strongSelf.timeRemaining -= 1
                } else {
                    strongSelf.timer?.invalidate()
                    strongSelf.moveToNextSession()
                }
            }
            isTimerRunning = true
        }
    }

    func resetSequence() {
        completedPomodoros = 0
        sessionType = .pomodoro
        timeRemaining = duration(for: .pomodoro)
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }

    func moveToNextSession() {
        if sessionType == .pomodoro {
            completedPomodoros += 1
            if completedPomodoros >= 4 {
                sessionType = .longBreak
            } else {
                sessionType = .shortBreak
            }
        } else {
            if completedPomodoros >= 4 && sessionType == .longBreak {
                resetSequence()
            } else {
                sessionType = .pomodoro
            }
        }
        timeRemaining = duration(for: sessionType)
    }

    func duration(for session: SessionType) -> Int {
        switch session {
        case .pomodoro:
            return 25 * 60 // 25 minutes
        case .shortBreak:
            return 5 * 60 // 5 minutes
        case .longBreak:
            return 15 * 60 // 15 minutes
        }
    }

    func timeFormatted() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func skipToNextSession() {
        let wasRunning = isTimerRunning
        timer?.invalidate()
        timer = nil
        isTimerRunning = false

        if completedPomodoros >= 3 && sessionType == .longBreak {
            resetSequence()
        } else {
            moveToNextSession()
        }

        if wasRunning {
            toggleTimer() // Restart the timer if it was running
        }
    }

    func rewindToPreviousSession() {
        let wasRunning = isTimerRunning
        timer?.invalidate()
        timer = nil
        isTimerRunning = false

        if sessionType == .pomodoro {
            if completedPomodoros > 0 {
                // If in the middle of a Pomodoro, go back to the previous break
                completedPomodoros -= 1
                sessionType = completedPomodoros % 4 == 0 ? .shortBreak : .longBreak
            }
        } else {
            // If in a break, go back to the previous Pomodoro
            sessionType = .pomodoro
        }

        timeRemaining = duration(for: sessionType)

        if wasRunning {
            toggleTimer() // Restart the timer if it was running
        }
    }
}
