//
//  FocusTimerApp.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//

import SwiftUI

@main
struct FocusTimerApp: App {
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                // Permission was granted
                print("Notification permission granted.")
            } else {
                // Permission was denied or an error occurred
                print("Notification permission denied.")
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
