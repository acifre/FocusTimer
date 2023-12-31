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
//                    .shadow(color: index < pomodoroTimer.completedPomodoros ? .white : .black , radius: 1, x: 0, y: 0)
                    .frame(width: 7.5, height: 7.5)
                    .glow()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: pomodoroTimer.completedPomodoros)
    }
}

struct Glow: ViewModifier {
    @Binding var throb: Bool
    func body(content: Content) -> some View {
        ZStack {
            content.blur(radius: throb ? 15 : 5)
                .animation(.easeOut(duration: 0.5).repeatForever(), value: throb)
                .onAppear(perform: {
                    throb.toggle()
                })

            content
        }
    }
}

extension View {
    func glow() -> some View {
        self.modifier(Glow(throb: .constant(true)))
    }
}


//#Preview {
//    SessionIndicatorsView()
//}
