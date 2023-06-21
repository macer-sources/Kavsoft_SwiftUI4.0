//
//  MotionManager.swift
//  A_15_3D Parallax Effect With Core Motion
//
//  Created by Kan Tao on 2023/6/21.
//

import Foundation
import CoreMotion



class MotionManager: ObservableObject  {
    @Published var manager:CMMotionManager = .init()
    @Published var xValue: CGFloat = 0
    @Published var currentSide:Place = sample_datas.first!
    
    func detectMotion() {
        guard !manager.isDeviceMotionActive else {
            return
        }
        
        manager.deviceMotionUpdateInterval = 1/40
        manager.startDeviceMotionUpdates(to: .main) { motion, error in
            if let attitude  = motion?.attitude {
                self.xValue = attitude.roll
            }
        }
    }
    
    
    // MARK: stopping update when it's
    func stopMotionUpdates() {
        manager.stopDeviceMotionUpdates()
    }
}
