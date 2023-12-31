//
//  TimerView.swift
//  MacPomodoro
//
//  Created by Anthony Cifre on 12/30/23.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var pomodoroTimer: PomodoroTimer

    var body: some View {
//        GeometryReader { geometry in
        VStack {

            ZStack {
                ProgressCircleView(progress: pomodoroTimer.progress, isTimerRunning: $pomodoroTimer.isTimerRunning)
                    .frame(width: 200, height: 200)

                VStack {

                    TimerDisplayView()

                    NextSessionView()
                }
            }

            SessionIndicatorsView()
                .padding(.vertical)

            ControlButtonsView()

            Button(action: {pomodoroTimer.resetSequence()}, label: {
                Text("Reset")
            })
            .tint(.red)

        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



// Dynamic Button Style
struct DynamicButtonStyle: ButtonStyle {
    var geometry: GeometryProxy

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(geometry.size.width * 0.045)
            .background(Color.gray.opacity(0.2))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    TimerView()
}
