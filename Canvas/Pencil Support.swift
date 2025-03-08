import SwiftUI

struct PencilSupport: UIViewRepresentable {
    @Binding var isDrawing: Bool
    @Binding var usingLassoTool: Bool
    
    func makeUIView(context: Context) -> UIView {
        let uiView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let pencilInteraction = UIPencilInteraction()
        pencilInteraction.isEnabled = true
        pencilInteraction.delegate = context.coordinator
        uiView.addInteraction(pencilInteraction)
        
        return uiView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    class Coordinator: NSObject, UIPencilInteractionDelegate {
        let parent: PencilSupport
        
        init(_ parent: PencilSupport) {
            self.parent = parent
        }
        
        func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
            withAnimation(.spring()) { 
                self.parent.isDrawing.toggle()
            }
        }
    }
}

extension View {
    func pencilSupport(isDrawing: Binding<Bool>, usingLassoTool: Binding<Bool>) -> some View {
        self
            .background {
                PencilSupport(isDrawing: isDrawing, usingLassoTool: usingLassoTool)
                    .frame(width: 0, height: 0)
            }
    }
}
