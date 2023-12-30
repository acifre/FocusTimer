//
//  ProgressCircleView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//

import SwiftUI

struct ProgressCircleView: View {
    var progress: CGFloat // Range from 0.0 to 1.0
    @Binding var isTimerRunning: Bool
    var body: some View {
        ZStack {
            // Grey background circle with animated progress
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)

            // Blue progress circle
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .butt, lineJoin: .miter))
                .rotationEffect(Angle(degrees: -90))
                .shadow(radius: 2)
                .transition(.scale)
        }
        .animation(.easeOut(duration: 0.5), value: progress)
    }
}

//#Preview {
//    ProgressCircleView()
//}
