//
//  NextSessionView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/30/23.
//

import SwiftUI

struct NextSessionView: View {
    @EnvironmentObject var pomodoroTimer: PomodoroTimer

    var body: some View {
        Text("Next Up: \(pomodoroTimer.nextSessionText)")
            .font(.headline)
    }
}


//#Preview {
//    NextSessionView()
//}
