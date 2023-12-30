//
//  ProgressCircleView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//

import SwiftUI

struct ProgressCircleView: View {
    var progress: CGFloat // Range from 0.0 to 1.0

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 20)

            // Animated progress circle
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear, value: progress)
        }
    }
}

//#Preview {
//    ProgressCircleView()
//}
