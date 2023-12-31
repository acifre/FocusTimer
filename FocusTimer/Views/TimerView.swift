////
////  TimerView.swift
////  FocusTimer
////
////  Created by Anthony Cifre on 12/29/23.
////
//
//import SwiftUI
//
//struct TimerView: View {
//    @EnvironmentObject var pomodoroTimer: PomodoroTimer
//
//    var body: some View {
////        GeometryReader { geometry in
//        VStack {
//
//            ZStack {
//                ProgressCircleView()
//                    .frame(width: 200, height: 200)
//
//                VStack {
//
//                    TimerDisplayView()
//
//                    NextSessionView()
//                }
//            }
//
//            SessionIndicatorsView()
//                .padding(.vertical)
//
//            ControlButtonsView()
//
//        }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}
//
//
//
//// Dynamic Button Style
//struct DynamicButtonStyle: ButtonStyle {
//    var geometry: GeometryProxy
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .padding(geometry.size.width * 0.045)
//            .background(Color.gray.opacity(0.2))
//            .clipShape(Circle())
//            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
//    }
//}
//
//
////#Preview {
////    TimerView()
////}
