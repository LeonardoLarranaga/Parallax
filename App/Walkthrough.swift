import SwiftUI

struct Walkthrough: ViewModifier {
    
    var step: Int
    var message: Text
    var messageAlignment: Alignment
    var offset: (x: CGFloat, y: CGFloat)
    
    var edge: Edge {
        messageAlignment.isIn(.bottomLeading, .leading, .topLeading) ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        messageAlignment.isIn(.bottomLeading, .leading, .topLeading) ? .leading : .trailing
    }
    
    var textAlignment: TextAlignment {
        messageAlignment.isIn(.bottomLeading, .leading, .topLeading) ? .leading : .trailing
    }
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("Walkthrough") var walkthrough = 0
    
    @State var showMessage = false
    
    func body(content: Content) -> some View {
        content
            .disabled(walkthrough == step)
            .background {
                showMessage ? (colorScheme == .light ? Color.gray : Color.black)
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all) : nil
            }
            .overlay(alignment: messageAlignment) {
                if showMessage {
                    VStack(alignment: horizontalAlignment) {
                        if messageAlignment.isIn(.top, .bottom) {
                            HStack {
                                Memoji()
                                Message()
                            }
                        } else {
                            Memoji()
                            Message()
                        }
                        
                        
                        Button {
                            withAnimation(.spring()) { 
                                walkthrough += 1
                            }
                        } label: {
                            if walkthrough == 8 {
                                Label("Done", systemImage: "paintpallette.fill")
                            } else {
                                Label("Next", systemImage: "arrowshape.bounce.right.fill")
                            }
                            
                        }
                        .labelStyle(.titleAndIcon)
                        .buttonStyle(.bordered)
                    }
                    .padding(10)
                    .background(.regularMaterial)
                    .cornerRadius(18)
                    .padding()
                    .transition(.move(edge: edge))
                    .frame(width: fullScreen.width, height: fullScreen.height, alignment: messageAlignment)
                    .offset(x: offset.x, y: offset.y)
                }
            }
            .onChange(of: walkthrough) { newValue in
                toggleShowMessage(newValue)
            }
            .onAppear {
                toggleShowMessage(walkthrough)
            }
    }
    
    func toggleShowMessage(_ walkthrough: Int) {
        withAnimation(.spring()) { 
            showMessage = walkthrough == step
        }
    }
    
    func Memoji() -> some View {
        Image("Memoji")
            .resizable()
            .scaledToFit()
            .frame(width: 55, height: 55)
    }
    
    func Message() -> some View {
        message
            .multilineTextAlignment(textAlignment)
            .font(.bodoni(.bold, size: 18))
    }
}

extension View {
    func walkthrough(_ step: Int, messageAlignment: Alignment, message: Text, offset: (x: CGFloat, y: CGFloat)) -> some View {
        modifier(Walkthrough(step: step, message: message, messageAlignment: messageAlignment, offset: offset))
    }
}

struct Walkthrough_Previews: PreviewProvider {
    static var previews: some View {
        TopLeftButtons(drawingOnCanva: .constant(true), canva: .init(), coreMotionManager: .init(), geometrySize: .constant(.zero), zoom: .constant(.zero), offset: .constant(.zero))
            .modifier(Walkthrough(step: 0, message: Text("Hello"), messageAlignment: .topLeading, offset: (x: 20, y: 20)))
    }
}
