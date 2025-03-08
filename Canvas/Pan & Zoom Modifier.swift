import SwiftUI

struct Pan: ViewModifier {
    
    @Binding var offset: CGSize
    
    func body(content: Content) -> some View {
        content
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        withAnimation(.spring()) {
                            offset = gesture.translation
                        }
                    }
            )
    }
}

struct Zoom: ViewModifier {
    @Binding var zoom: CGFloat
    @Binding var offset: CGSize
    func body(content: Content) -> some View {
        content
            .scaleEffect(zoom)
            .gesture(
                MagnificationGesture()
                    .onChanged { gesture in 
                        withAnimation(.spring()) {
                            if gesture > 3 {
                                zoom = 3
                            } else {
                                zoom = gesture
                            }
                        }
                    }
                    .onEnded { gesture in
                        withAnimation(.spring()) {
                            if gesture < 0.7 {
                                zoom = 0.7
                                offset = .zero
                            }
                        }
                    }
            )
    }
}
