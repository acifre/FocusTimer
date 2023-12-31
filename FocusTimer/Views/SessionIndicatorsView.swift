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
                    .frame(width: 7.5, height: 7.5)
                    .if(pomodoroTimer.sessionType == .pomodoro && index == pomodoroTimer.completedPomodoros && pomodoroTimer.isTimerRunning) { view in
                        view.modifier(Glow(shape: Circle(), lineWidth: 1.5))
                }
            }
        }
    }
}



struct Glow<S: Shape>: ViewModifier {
    @State private var isAnimating = false
    let shape: S
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                shape
                    .stroke(Color.blue, lineWidth: lineWidth)
                    .scaleEffect(isAnimating ? 1.5 : 1)
                    .opacity(isAnimating ? 0 : 1)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                    .onAppear { self.isAnimating = true }
            )
    }
}



extension View {
    func glow<S: Shape>(shape: S, lineWidth: CGFloat = 3) -> some View {
        self.modifier(Glow(shape: shape, lineWidth: lineWidth))
    }
}


extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


//#Preview {
//    SessionIndicatorsView()
//}
