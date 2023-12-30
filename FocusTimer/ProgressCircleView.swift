//
//  ProgressCircleView.swift
//  FocusTimer
//
//  Created by Anthony Cifre on 12/29/23.
//

import SwiftUI

struct ProgressCircleView: View {
    var progress: CGFloat  // Range from 0.0 to 1.0

    var body: some View {
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear, value: progress)
        }
}

//#Preview {
//    ProgressCircleView()
//}
