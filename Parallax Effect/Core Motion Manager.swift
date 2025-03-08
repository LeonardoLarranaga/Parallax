import SwiftUI
import CoreMotion

class CoreMotionManager: ObservableObject {
    @Published var manager = CMMotionManager()
    @Published var xOffset = CGFloat.zero
    @Published var yOffset = CGFloat.zero
    @Published var isActive = false
    
    func detectMotion() {
        if manager.isDeviceMotionActive == false {
            manager.startDeviceMotionUpdates(to: .main) { motion, error in
                if let attitude = motion?.attitude {
                    self.xOffset = attitude.pitch
                    self.yOffset = attitude.roll
                }
            }
        }
    }
    
    func stopMotionUpdates() {
        manager.stopDeviceMotionUpdates()
    }
    
    func toggle() {
        if manager.isDeviceMotionActive {
            stopMotionUpdates()
            isActive = false
        } else {
            isActive = true
            detectMotion()
        }
    }
}
