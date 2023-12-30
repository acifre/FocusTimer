//
//  ContentView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//
import SwiftUI

struct ContentView: View {
    // Initialize PomodoroTimer with a 25 minutes countdown
    @StateObject private var pomodoroTimer = PomodoroTimer()

    var body: some View {
        TimerView(pomodoroTimer: pomodoroTimer)
    }
}

#Preview {
    ContentView()
}
