//
//  TimerView.swift
//  MacPomodoro
//
//  Created by Anthony Cifre on 12/30/23.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var pomodoroTimer: PomodoroTimer
    @State private var intent = ""
    @State private var isEditing = true

    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if isEditing {
                    TextField("Intention?", text: $intent, onCommit: {
                        withAnimation {
                            isEditing = false

                            if !pomodoroTimer.isTimerRunning {
                                pomodoroTimer.toggleTimer()
                            }
                        }
                    })
                        .frame(width: 100.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($isFocused)
                } else {
                    Text(intent)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        .onTapGesture {
                        withAnimation {
                            isEditing = true

                        }
                    }
                        .focused($isFocused)
                }

                ZStack {
                    ProgressCircleView()
                        .padding(pomodoroTimer.isTimerRunning ? 10 : 20)
                        .frame(width: 250, height: 250)

                    VStack {

                        SessionIndicatorsView()

                        TimerDisplayView()
                            .padding(.vertical, pomodoroTimer.isTimerRunning ? 15 : 7)
                        NextSessionView()
                    }
                }
                    .padding(.vertical, pomodoroTimer.isTimerRunning ? 12 : 10)


                ControlButtonsView(intent: $intent, isEditing: $isEditing)

            }
            .animation(.easeInOut(duration: 0.5), value: pomodoroTimer.isTimerRunning)
                .onAppear {
                isFocused = true
            }

            #if os(macOS)
                .frame(width: 500.0, height: 700.0)
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                    .scaleEffect(x: 1.25, y: 1.25, anchor: .center)
            #endif
        }
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

#if os(macOS)

    extension NSTextField {
        open override var focusRingType: NSFocusRingType {
            get { .none }
            set { }
        }
    }
#endif

#Preview {
    TimerView()
        .environmentObject(PomodoroTimer())
}
