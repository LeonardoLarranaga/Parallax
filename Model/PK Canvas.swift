import SwiftUI
import PencilKit

struct PKCanvas: UIViewRepresentable {
    @Environment(\.managedObjectContext) var context
    
    let layer: Layer
    var currentLayer: UUID
    
    @Binding var isDrawing: Bool
    @Binding var inkingTool: PKInkingTool
    @Binding var inkColor: Color
    @Binding var inkOpacity: CGFloat
    @Binding var usingLassoTool: Bool
    @Binding var isRulerActive: Bool
    
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas =  PKCanvasView()
        
        canvas.isOpaque = true
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .pencilOnly
        canvas.isScrollEnabled = false
        
        do {
            canvas.drawing = try PKDrawing(data: layer.wrappedData)
        } catch {}
        
        canvas.delegate = context.coordinator
        
        return canvas
    }
    
    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        
        self.inkingTool.color = UIColor(self.inkColor.opacity(inkOpacity))
        
        if usingLassoTool {
            canvas.tool = PKLassoTool()
        } else {
            canvas.tool = isDrawing ? inkingTool : PKEraserTool(.bitmap)
        }
        
        canvas.isRulerActive = isRulerActive && currentLayer == layer.id
        
        do {
            canvas.drawing = try PKDrawing(data: layer.wrappedData)
        } catch {}

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        
        let parent: PKCanvas
        
        init(_ parent: PKCanvas) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            self.parent.layer.data = canvasView.drawing.dataRepresentation()
            try? self.parent.context.save()
        }
    }
}
