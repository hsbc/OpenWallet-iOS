//
//  ShakeManager.swift
//  OpenWallet
//
//  Created by fanjianrong on 2022/10/28.
//

import Foundation
import CoreMotion

@MainActor
class ShakeManager: ObservableObject {
    
    enum ShakeSensitivity: Double {
        case higher = 3
        case high = 4
        case normal = 5
        case low = 7
        case lower = 10
    }
    
    static let shared = ShakeManager()
    
    @Published var didShake = false
    
    let minShakeValue = 1.0
    var motionManager = CMMotionManager()
    var shakeSensivity = ShakeSensitivity.low
    
    func startAccelerometer() {
        motionManager.startAccelerometerUpdates(to: OperationQueue()) { data, _ in
            guard let accelerometerData = data else {
                return
            }
            if self.sensivityValid(acceleration: accelerometerData.acceleration) {
                DispatchQueue.main.async {
                    if self.didShake == false {
                        OHLogInfo("shake log")
                        self.didShake = true
                    }
                }
            }
            
        }
    }
    
    func sensivityValid(acceleration: CMAcceleration) -> Bool {
        let xValue = sqrt(pow(acceleration.x, 2))
        let yValue = sqrt(pow(acceleration.y, 2))
        let zValue = sqrt(pow(acceleration.z, 2))
        let isX = xValue > minShakeValue
        let isY = yValue > minShakeValue
        let isZ = zValue > minShakeValue
        if (isX && isY) || (isX && isZ) || (isY && isZ) {
            let accelerometer = xValue + yValue + zValue
            if accelerometer > shakeSensivity.rawValue {
                return true
            }
        }
        return false
    }
}
