//
//  FocusTimerApp.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//

import SwiftUI
import UserNotifications

@main
struct FocusTimerApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var pomodoroTimer = PomodoroTimer()

    private let notificationDelegate = NotificationDelegate()

//    #if !os(iOS)

//    init() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                // Permission was granted
//                print("Notification permission granted.")
//            } else {
//                // Permission was denied or an error occurred
//                print("Notification permission denied.")
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//        }
//
//        let notificationCenter = UNUserNotificationCenter.current();
//    }

//    #endif

//    #if os(macOS)
        init() {
            requestNotificationPermission()
            UNUserNotificationCenter.current().delegate = notificationDelegate
        }

//    #endif

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroTimer)

                .onChange(of: scenePhase) {
                switch scenePhase {
                case .background:
                    pomodoroTimer.applicationDidEnterBackground()
                case .active:
                    pomodoroTimer.applicationWillEnterForeground()
                default:
                    break
                }
            }
                .preferredColorScheme(.dark)
        }
        .defaultSize(width: 700, height: 700)
        .windowResizability(.contentSize)
    }
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error here.
                print("Error: \(error)")
            }
            // Enable or disable features based on the authorization.
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle foreground notification.
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the user's response to the notification (e.g., tapping on it).
        completionHandler()
    }
}
