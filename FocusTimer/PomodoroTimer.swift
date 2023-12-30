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
    var timer: Timer?
    var sessionType: SessionType
    var completedPomodoros: Int

    init() {
        self.sessionType = .pomodoro
        self.completedPomodoros = 0
        self.timeRemaining = 25 * 60 // Directly initializing with Pomodoro duration
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let strongSelf = self else { return }

            if strongSelf.timeRemaining > 0 {
                strongSelf.timeRemaining -= 1
            } else {
                strongSelf.timer?.invalidate()
                strongSelf.moveToNextSession()
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate()
    }

    func resetTimer() {
        timer?.invalidate()
        sessionType = .pomodoro
        completedPomodoros = 0
        timeRemaining = duration(for: .pomodoro)
    }

    func moveToNextSession() {
        if sessionType == .pomodoro {
            completedPomodoros += 1
            sessionType = completedPomodoros % 4 == 0 ? .longBreak : .shortBreak
        } else {
            sessionType = .pomodoro
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
        timer?.invalidate()
        moveToNextSession()
        startTimer()
    }

    func rewindToPreviousSession() {
        timer?.invalidate()

        if sessionType == .pomodoro && completedPomodoros > 0 {
            if completedPomodoros % 4 == 0 {
                // Rewind from the start of a Pomodoro session to the long break
                sessionType = .longBreak
            } else {
                // Rewind from the start of a Pomodoro session to the short break
                sessionType = .shortBreak
            }
            completedPomodoros -= 1
        } else if sessionType == .shortBreak || sessionType == .longBreak {
            // Rewind from a break to the previous Pomodoro session
            sessionType = .pomodoro
        }

        timeRemaining = duration(for: sessionType)
    }
}
