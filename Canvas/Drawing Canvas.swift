import SwiftUI
import PencilKit

struct DrawingCanvas: View {
    
    let canva: Canva
    
    @StateObject var coreMotionManager = CoreMotionManager()
    
    @Binding var drawingOnCanva: Bool
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context
    
    @State var isDrawing = true
    @State var inkingTool = PKInkingTool(.pencil, color: UIColor(.blue), width: 10)
    @State var inkColor = Color.blue
    @State var inkOpacity: CGFloat = 1
    @State var inkWidth: CGFloat = 10
    @State var usingLassoTool = false
    @State var isRulerActive = false
    
    @State var zoom: CGFloat = 1.0
    @State var offset = CGSize.zero
    @State var geometrySize = CGSize.zero
    
    @State var currentLayer = UUID()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    ForEach(canva.layersArray.reversed().filter({$0.isVisible})) { layer in
                        PKCanvas(layer: layer, currentLayer: currentLayer, isDrawing: $isDrawing, inkingTool: $inkingTool, inkColor: $inkColor, inkOpacity: $inkOpacity, usingLassoTool: $usingLassoTool, isRulerActive: $isRulerActive)
                            .parallax(coreMotionManager, degreesMultiplier: layer.position % 2 == 0 ? 20 : -20, multiplier3D: (x: layer.position % 2 == 0 ? 10 : -10, y: layer.position % 2 == 0 ? 30 : -30, z: layer.position % 2 == 0 ? 10 : -10), anchorZMultiplier: layer.position % 2 == 0 ? 10 : -10, perspectiveMultiplier: layer.position % 2 == 0 ? 20 : -20, xOffsetMultiplier: layer.position % 2 == 0 ? 50 : -50, yOffsetMultiplier: layer.position % 2 == 0 ? 50 : -50)
                            .disabled(currentLayer != layer.id)
                    }
                }
                .cornerRadius(12)
                .shadow(color: .secondary.opacity(colorScheme == .light ? 0.2 : 0.5), radius: colorScheme == .light ? 25 : 55, x: 0, y: 0)
                .modifier(Pan(offset: $offset))
                .modifier(Zoom(zoom: $zoom, offset: $offset))
                .walkthrough(2, messageAlignment: .top, message: Text("Here's where you make your (hopefully) beautiful art."), offset: (x: 0, y: 0))
                .walkthrough(8, messageAlignment: .top, message: Text("That's everything you need to know. Have fun!"), offset: (x: 0, y: 0))
            
            LayersPanel(canva: canva, currentLayer: $currentLayer, drawingOnCanva: $drawingOnCanva)
                .walkthrough(5, messageAlignment: .leading, message: Text("These are your tools, we have a pencil, pen, marker, lasso, ruler, and eraser."), offset: (x: 50, y: 0))
            
            ToolSelector(inkingTool: $inkingTool, inkColor: $inkColor, isDrawing: $isDrawing, usingLassoTool: $usingLassoTool, isRulerActive: $isRulerActive)
                .walkthrough(4, messageAlignment: .topTrailing, message: Text("Here are your layers.\nYou can add, remove, hide, \nmove a layer up or down, and rename it."), offset: (x: -250, y: 0))
            
            ColorSlideshow(inkingTool: $inkingTool, inkColor: $inkColor, inkOpacity: $inkOpacity)
                .walkthrough(7, messageAlignment: .bottom, message: Text("I think these are obvious. (They change the color of your tool)."), offset: (x: 0, y: -85))
            
            CanvaSliders(isDrawing: isDrawing, inkingTool: $inkingTool, inkOpacity: $inkOpacity, inkColor: $inkColor, inkWidth: $inkWidth)
                .walkthrough(6, messageAlignment: .bottomLeading, message: Text("You can also adjust the \nsize and opactiy of your tool."), offset: (x: 165, y: 0))
            
            
        }
        .background(Color(uiColor: colorScheme == .light ? UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00) : UIColor(red: 0.13, green: 0.13, blue: 0.14, alpha: 1.00)).ignoresSafeArea())
        .background {
            GeometryReader { geometry in 
                Color.clear
                    .onAppear {
                        geometrySize = geometry.size
                    }
                    .onChange(of: geometry.size) { newValue in
                        geometrySize = newValue
                    }
            }
        }
        .scaleEffect(!drawingOnCanva ? 0.2 : 1)
        .ignoresSafeArea(.keyboard, edges: .all)
        .task {
            withAnimation(.spring()) {
                zoom = 0.7
            }
            currentLayer = canva.layersArray.last?.id ?? UUID()
        }
        .overlay {
            ZStack {
                TopLeftButtons(drawingOnCanva: $drawingOnCanva, canva: canva, coreMotionManager: coreMotionManager, geometrySize: $geometrySize, zoom: $zoom, offset: $offset)
                    .walkthrough(3, messageAlignment: .topLeading, message: Text("Here's what those little icons do:\n\n") + Text(Image(systemName: "xmark")).foregroundColor(.blue) + Text(" closes your drawing.\n") + Text(Image(systemName: "move.3d")).foregroundColor(.blue) + Text(" toggles the parallax effect on your drawing.\n") + Text(Image(systemName: "camera.metering.matrix")).foregroundColor(.blue) + Text(" opens your drawing in AR. 😎\n") + Text(Image(systemName: "1.magnifyingglass")).foregroundColor(.blue) + Text(" restores the zoom on the canvas.\n") + Text(Image(systemName: "arrowshape.turn.up.backward")).foregroundColor(.blue) + Text(Image(systemName: "arrowshape.turn.up.forward")).foregroundColor(.blue) + Text(" your classic undo and redo buttons. You can also use ⌘Z and ⌘⇧Z.\n"), offset: (x: 0, y: 75))
                
                if geometrySize.width != fullScreen.width || geometrySize.width < geometrySize.height {
                    Rectangle()
                        .fill(.ultraThickMaterial)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("For now, you need to use Parallax in full screen and landscape mode.")
                            .font(.bodoni(.extraBold, size: 32))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Text("If you're already on full screen and landscape mode, just restart the playground. :)")
                            .font(.bodoni(.bold, size: 24))
                            .multilineTextAlignment(.center)
                    }
                    
                }
            }
        }
        .onDisappear(perform: coreMotionManager.stopMotionUpdates)
    }
}
