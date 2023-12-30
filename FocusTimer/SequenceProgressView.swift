//
//  SequenceProgressView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//

import SwiftUI

struct SequenceProgressView: View {
    @ObservedObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        VStack {
            Text("Current Session: \(sessionName(for: pomodoroTimer.sessionType))")
                .font(.headline)
                .padding()

            HStack {
                ForEach(0..<4, id: \.self) { index in
                    Image(systemName: index < pomodoroTimer.completedPomodoros ? "circle.fill" : "circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
            }
            .padding()
            .transition(.scale)
        }
    }

    private func sessionName(for sessionType: PomodoroTimer.SessionType) -> String {
        switch sessionType {
        case .pomodoro:
            return "Pomodoro"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }
}


//#Preview {
//    SequenceProgressView()
//}
