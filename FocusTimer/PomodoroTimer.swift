//
//  PomodoroTimer.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//
import Foundation
import UserNotifications
import AudioToolbox


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

    var backgroundEntryTime: Date?

    init() {
        self.sessionType = .pomodoro
        self.completedPomodoros = 0
        self.timeRemaining = 1 * 60 // Directly initializing with Pomodoro duration
    }

    func applicationDidEnterBackground() {
        backgroundEntryTime = Date()
        scheduleRemainingNotifications()
    }

    func applicationWillEnterForeground() {
        if let backgroundEntryTime = backgroundEntryTime {
            let timeInBackground = Date().timeIntervalSince(backgroundEntryTime)
            adjustTimerForBackgroundElapsedTime(timeInBackground)
            self.backgroundEntryTime = nil // Reset the background entry time
        }
    }

    private func adjustTimerForBackgroundElapsedTime(_ elapsed: TimeInterval) {
        let elapsedTimeInSeconds = Int(elapsed)
        timeRemaining -= elapsedTimeInSeconds

        if timeRemaining <= 0 {
            moveToNextSession()
        }
    }

    func timeFormatted() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func duration(for session: SessionType) -> Int {
        switch session {
        case .pomodoro:
            return 1 * 60 // 25 minutes
        case .shortBreak:
            return 1 * 60 // 5 minutes
        case .longBreak:
            return 1 * 60 // 15 minutes
        }
    }

    func toggleTimer() {
        isTimerRunning ? stopTimer() : startTimer()
    }

    private func startTimer() {
        stopTimer() // Ensure no timer is already running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        isTimerRunning = true
        scheduleCurrentSessionNotification()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        cancelScheduledNotification()
    }

    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            // stopTimer() // Stop the timer
            moveToNextSession()
            playSound()
        }
    }

    func moveToNextSession() {
        transitionToNextSession()
        timeRemaining = duration(for: sessionType)
        if isTimerRunning {
            startTimer()
        }
    }

    private func transitionToNextSession() {
        if sessionType == .pomodoro {
            completedPomodoros += 1
            sessionType = completedPomodoros % 4 == 0 ? .longBreak : .shortBreak
        } else if completedPomodoros >= 4 && sessionType == .longBreak {
            resetSequence()
        } else {
            sessionType = .pomodoro
        }
    }

    func resetSequence() {
        completedPomodoros = 0
        sessionType = .pomodoro
        timeRemaining = duration(for: .pomodoro)
        stopTimer()
    }

    func skipToNextSession() {
        let wasRunning = isTimerRunning
        stopTimer()
        transitionToNextSession()
        timeRemaining = duration(for: sessionType)
        if wasRunning {
            startTimer()
        }
    }

    func rewindToPreviousSession() {
        let wasRunning = isTimerRunning
        stopTimer()
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        cancelScheduledNotification()

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
            startTimer() // Restart the timer if it was running
        }
    }

    private func scheduleNotification(for sessionType: SessionType, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = sessionType == .pomodoro ? "Pomodoro Finished" : "Break Finished"
        content.body = "Your \(sessionType == .pomodoro ? "Pomodoro" : "Break") session has ended."
        content.sound = UNNotificationSound.default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    private func scheduleCurrentSessionNotification() {
            let sessionEndTime = Date().addingTimeInterval(Double(timeRemaining))
            scheduleNotification(for: sessionType, at: sessionEndTime)
        }

    private func scheduleRemainingNotifications() {
        let currentSessionEndTime = backgroundEntryTime?.addingTimeInterval(Double(timeRemaining))
        var nextSessionTime = currentSessionEndTime
        var sessionsLeft = 4 - completedPomodoros

        while sessionsLeft > 0 {
            guard let nextSessionStart = nextSessionTime else { break }

            // Determine next session type
            let nextSessionType = sessionType == .pomodoro ? SessionType.shortBreak : SessionType.pomodoro
            let nextSessionDuration = duration(for: nextSessionType)

            // Schedule notification for next session end
            scheduleNotification(for: nextSessionType, at: nextSessionStart.addingTimeInterval(Double(nextSessionDuration)))

            // Prepare for next iteration
            nextSessionTime = nextSessionStart.addingTimeInterval(Double(nextSessionDuration))
            sessionsLeft -= 1
        }

        // Schedule final notification if all sessions are completed
        if sessionsLeft == 0, let finalTime = nextSessionTime {
            scheduleFinalNotification(at: finalTime)
        }
    }

    private func scheduleFinalNotification(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "All Finished!"
        content.body = "Well done! You've completed all your Pomodoro sessions."
        content.sound = UNNotificationSound.default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }



    private func cancelScheduledNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func playSound() {
        let systemSoundID: SystemSoundID = 1005
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
