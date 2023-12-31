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
        TimerView()
    }
}

#Preview {
    ContentView()
}
