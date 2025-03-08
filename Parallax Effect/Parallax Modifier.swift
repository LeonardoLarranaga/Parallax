import SwiftUI

struct ParallaxModifier: ViewModifier {
    
    @ObservedObject var coreMotionManager: CoreMotionManager
    let degreesMultiplier: CGFloat
    let multiplier3D: (x: CGFloat, y: CGFloat, z: CGFloat)
    let anchorZMultiplier: CGFloat
    let perspectiveMultiplier: CGFloat
    let xOffsetMultiplier: CGFloat
    let yOffsetMultiplier: CGFloat
    
    func body(content: Content) -> some View {
        if coreMotionManager.isActive {
            content
                .rotation3DEffect(.degrees(coreMotionManager.xOffset * degreesMultiplier), axis: (x: multiplier3D.x, y: multiplier3D.y, z: multiplier3D.z), anchor: .center, anchorZ: coreMotionManager.yOffset * anchorZMultiplier, perspective: coreMotionManager.xOffset * perspectiveMultiplier)
                .offset(x: coreMotionManager.xOffset * xOffsetMultiplier, y: coreMotionManager.yOffset * yOffsetMultiplier)
                .onAppear(perform: coreMotionManager.detectMotion)
                .onDisappear(perform: coreMotionManager.stopMotionUpdates)
        } else {
            content
        }
    }
}

extension View {
    func parallax(_ coreMotionManager: CoreMotionManager, degreesMultiplier: CGFloat = 10, multiplier3D: (x: CGFloat, y: CGFloat, z: CGFloat) = (x: 20, y: 30, z: 20), anchorZMultiplier: CGFloat = 0, perspectiveMultiplier: CGFloat = 20, xOffsetMultiplier: CGFloat = 55, yOffsetMultiplier: CGFloat = 55) -> some View {
        modifier(ParallaxModifier(coreMotionManager: coreMotionManager, degreesMultiplier: degreesMultiplier, multiplier3D: multiplier3D, anchorZMultiplier: anchorZMultiplier, perspectiveMultiplier: perspectiveMultiplier, xOffsetMultiplier: xOffsetMultiplier, yOffsetMultiplier: yOffsetMultiplier))
    }
}

struct ParallaxModifier_Previews: PreviewProvider {
    static var previews: some View {
        ParallaxTitle()
    }
}
