//
//  ContentView.swift
//  MacPomodoro
//
//  Created by Anthony Cifre on 12/30/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        NavigationStack {
            TabView {
                TimerView()
                    .tabItem {
                        Label("Timer", systemImage: "timer")
                    }
//                Text("History")
//                    .tabItem {
//                        Label("History", systemImage: "clock")
//                    }
//
//                Text("Settings")
//                    .tabItem {
//                        Label("Settings", systemImage: "gearshape")
//                    }
            }
            .background()

        }
        .background()

        .navigationTitle("Focus Timer")

    }
}

#Preview {
    ContentView()
        .environmentObject(PomodoroTimer())
}
