import SwiftUI
import PencilKit

func PKCanvasExport(canva: Canva? = nil, layer: Layer? = nil, displayScale: CGFloat) -> UIImage {
    var drawing = PKDrawing()
    let rect = CGRect(x: 0, y: 0, width: fullScreen.width, height: fullScreen.height)
    
    do {
        if let canva {
            for layer in canva.layersArray.reversed().filter({ $0.isVisible }) {
                drawing.append(try PKDrawing(data: layer.wrappedData))
            }
        } else if let layer {
            drawing = try PKDrawing(data: layer.wrappedData)
        }
    } catch {
    }   
    
    return drawing.image(from: rect, scale: displayScale)
}
