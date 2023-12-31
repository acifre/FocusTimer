//
//  PomodoroTimer.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//
import Foundation
import UserNotifications
import AudioToolbox
#if os(macOS)
import AppKit
#endif


class PomodoroTimer: ObservableObject {
    enum SessionType {
        case pomodoro
        case shortBreak
        case longBreak
    }

    @Published var timeRemaining: Int
    @Published var isTimerRunning = false
    @Published var completedPomodoros: Int
    @Published var intent: String
    @Published var isEditing = false

    var timer: Timer?
    var sessionType: SessionType

    var backgroundEntryTime: Date?

    init() {
        self.sessionType = .pomodoro
        self.completedPomodoros = 0
        self.timeRemaining = 25 * 60 // Directly initializing with Pomodoro duration
        self.intent = ""
    }

    var progress: CGFloat {
        let totalDuration = CGFloat(duration(for: sessionType))
        let remaining = CGFloat(timeRemaining)
        return 1.0 - (remaining / totalDuration)
    }

    var nextSessionText: String {
        switch sessionType {
        case .pomodoro:
            return completedPomodoros >= 3 ? "Finish" : "Break"
        case .shortBreak:
            return "Focus"
        case .longBreak:
            return "Another round?"
        }
    }

    func applicationDidEnterBackground() {
        backgroundEntryTime = Date()
        cancelScheduledNotification() // Cancel current session notification
        scheduleRemainingNotifications() // Schedule notifications for the remaining sequence
    }

    func applicationWillEnterForeground() {
        guard let backgroundEntryTime = backgroundEntryTime else { return }
        let totalElapsedTime = Date().timeIntervalSince(backgroundEntryTime)

        adjustTimerAndSession(forElapsedTime: totalElapsedTime)
    }

    private func adjustTimerAndSession(forElapsedTime elapsed: TimeInterval) {
        var remainingTime = elapsed
        while remainingTime > 0 && completedPomodoros < 4 {
            let sessionDuration = Double(duration(for: sessionType))
            if remainingTime < sessionDuration {
                timeRemaining = Int(sessionDuration - remainingTime)
                break
            } else {
                moveToNextSession()
                remainingTime -= sessionDuration
            }
        }

        if completedPomodoros >= 4 {
            resetSequence()
        } else if isTimerRunning {
            startTimer()
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
            return 25 * 60 // 25 minutes
        case .shortBreak:
            return 5 * 60 // 5 minutes
        case .longBreak:
            return 15 * 60 // 15 minutes
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

//    private func scheduleNotification(for sessionType: SessionType, at date: Date) {
//        let content = UNMutableNotificationContent()
//        content.title = sessionType == .pomodoro ? "Pomodoro Finished" : "Break Finished"
//        content.body = "Your \(sessionType == .pomodoro ? "Pomodoro" : "Break") session has ended."
//        content.sound = UNNotificationSound.default
//
//        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request)
//    }

//    #if os(macOS)

    func scheduleNotification(for sessionType: SessionType, at date: Date) {
            let content = UNMutableNotificationContent()
            content.title = sessionType == .pomodoro ? "Pomodoro Finished" : "Break Finished"
            content.body = "Your \(sessionType == .pomodoro ? "Pomodoro" : "Break") session has ended."
            content.sound = UNNotificationSound.default

            let interval = date.timeIntervalSinceNow
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(interval, 1), repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    // Handle any errors.
                    print("Error: \(error)")
                }
            }
        }
//    #endif

    private func scheduleCurrentSessionNotification() {
        let sessionEndTime = Date().addingTimeInterval(Double(timeRemaining))
        scheduleNotification(for: sessionType, at: sessionEndTime)
    }

    private func scheduleRemainingNotifications() {
        var nextSessionEndTime = backgroundEntryTime?.addingTimeInterval(Double(timeRemaining))
        var nextSessionType = sessionType
        var sessionsLeft = 4 - completedPomodoros

        while sessionsLeft > 0 {
            guard let endTime = nextSessionEndTime else { break }

            scheduleNotification(for: nextSessionType, at: endTime)

            // Check if this is the final session
            if sessionsLeft == 1 && nextSessionType == .pomodoro {
                let finalBreakType = SessionType.longBreak
                let finalBreakDuration = duration(for: finalBreakType)
                let finalBreakEndTime = endTime.addingTimeInterval(Double(finalBreakDuration))
                scheduleFinalNotification(at: finalBreakEndTime)
                break // Exit after scheduling the final notification
            }

            // Prepare for the next session
            nextSessionType = nextSessionType == .pomodoro ? .shortBreak : .pomodoro
            let nextSessionDuration = duration(for: nextSessionType)
            nextSessionEndTime = endTime.addingTimeInterval(Double(nextSessionDuration))
            sessionsLeft -= (nextSessionType == .pomodoro) ? 1 : 0
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
        #if os(iOS)
        let systemSoundID: SystemSoundID = 1005
        AudioServicesPlaySystemSound(systemSoundID)
        #elseif os(macOS)
        if let sound = NSSound(named: "Funk") {
            sound.play()
        }
        #endif
    }

}


