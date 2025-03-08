import SwiftUI

struct ParallaxTitle: View {
    
    @State var center = UnitPoint.center
    @AppStorage("FinishedWelcome") var finishedWelcome = false
    @State var opacity = 1.0
    @StateObject var coreMotionManager = CoreMotionManager()
    
    var body: some View {
        ZStack {
            AngularGradient(colors: [.blue, .cyan, .blue, .cyan, .cyan], center: center, angle: .degrees(45))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .overlay(.thinMaterial)
                .animation(.easeIn(duration: 1.5), value: center)
            
            VStack {
                VStack {
                    Text("Parallax.")
                        .font(.bodoni(.bold, size: 120))
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                        .parallax(coreMotionManager, degreesMultiplier: 20, multiplier3D: (x: 10, y: 30, z: 10), anchorZMultiplier: 10, perspectiveMultiplier: 20, xOffsetMultiplier: 50, yOffsetMultiplier: 50)
                    
                    HStack {
                        Text("noun")
                            .font(.bodoni(.boldItalic, size: 28))
                        
                        Text("• /ˈper.ə.læks/ •")
                            .font(.bodoni(.italic, size: 28))
                        
                        Spacer()
                    }
                    .padding([.bottom, .leading], 35)
                    
                    Text("the effect whereby the position or direction of an object appears to differ when viewed from different positions, e.g. through the viewfinder and the lens of a camera.")
                        .parallax(coreMotionManager, degreesMultiplier: 0, multiplier3D: (x: 5, y: 5, z: 0), anchorZMultiplier: 0, perspectiveMultiplier: 0, xOffsetMultiplier: -55, yOffsetMultiplier: -55)
                        .font(.bodoni(.black, size: 32))
                        .font(.largeTitle.bold())
                    
                    Text("Try moving your iPad. :)")
                        .font(.bodoni(.semibold, size: 18))
                        .padding(.vertical)
                }
                .shadow(color: .accentColor.opacity(0.3), radius: 3)
                .foregroundStyle(.ultraThickMaterial)
                
                Button("Start Experience") {
                    withAnimation(.spring()) {
                        finishedWelcome = true
                    }
                }
                .font(.bodoni(.bold, size: 22))
                .padding(10)
                .background(.blue.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top)
            }
           
        }
        .onDisappear(perform: coreMotionManager.stopMotionUpdates)
        .onAppear {
            coreMotionManager.toggle()
            
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
                if finishedWelcome {
                    timer.invalidate()
                } else { 
                    center = [UnitPoint.center, .bottom, .bottomLeading, .bottomTrailing, .leading, .topLeading, .topTrailing, .top].randomElement()!
                }
            }
        }
    }
}

struct ParallaxTitle_Previews: PreviewProvider {
    static var previews: some View {
        ParallaxTitle()
    }
}
