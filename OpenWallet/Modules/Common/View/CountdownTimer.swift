//
//  CountdownTimer.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 6/24/22.
//

import SwiftUI
import Foundation

struct CountdownTimer: View {
    @Environment(\.scenePhase) var scenePhase
    @Binding var timeRemaining: TimeInterval
    
    // Callback function when remaining time is zero. [weihao.zhang]
    var timeIsUp: (() -> Void)?
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    @State private var isActive: Bool = true
    @State private var enteredBackground: Bool = false
    
    @State private var stopCountdownDateTime: Date = Date.distantPast

    var body: some View {
        VStack {
            Text("\(formatter.string(from: timeRemaining)!)\(showSecondsIndicator ? " s" : "")")
                .font(Font.custom("SFProText-Regular", size: FontSize.caption))
                .onReceive(timer) { _ in
                    guard isActive else { return }

                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        guard timeIsUp != nil else { return }
                        timeIsUp!()
                    }
                }
        }
        .onChange(of: scenePhase) { newPhase in
            scenePhaseHandler(newPhase)
        }
    }
}

extension CountdownTimer {
    func scenePhaseHandler(_ scenePhase: ScenePhase) {
        if scenePhase == .active {
            isActive = true
            enteredBackground = false
            guard stopCountdownDateTime != Date.distantPast else { return }
            
            let timeElapsed = round(Date.now.timeIntervalSince(stopCountdownDateTime))
            
            // Reset enterBackgroundDateTime. [weihao.zhang]
            stopCountdownDateTime = Date.distantPast
            
            if timeElapsed > timeRemaining {
                timeRemaining = 0
            } else {
                timeRemaining -= timeElapsed
            }
        } else if scenePhase == .inactive {
            guard !enteredBackground else { return }
            
            isActive = false
            stopCountdownDateTime = Date.now
        } else if scenePhase == .background {
            isActive = false
            enteredBackground = true
            stopCountdownDateTime = Date.now
        }
    }
    
    private var showSecondsIndicator: Bool {
        return timeRemaining < 60
    }
}

struct CountdownTimer_Previews: PreviewProvider {
    @State static var remainingTime: TimeInterval = 300

    static var previews: some View {
        CountdownTimer(timeRemaining: $remainingTime)
    }
}
