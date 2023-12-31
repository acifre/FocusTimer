//
//  SessionIndicatorsView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/30/23.
//

import SwiftUI

struct SessionIndicatorsView: View {
    @EnvironmentObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<4, id: \.self) { index in
                Circle()
                    .fill(index < pomodoroTimer.completedPomodoros ? Color.blue : Color.gray)
                    .frame(width: 15, height: 15)
            }
        }
    }
}


//#Preview {
//    SessionIndicatorsView()
//}
