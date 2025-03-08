import SwiftUI
import PencilKit

struct CanvaSliders: View {

    @State var appear = false
    var isDrawing: Bool
    @Binding var inkingTool: PKInkingTool
    @Binding var inkOpacity: CGFloat
    @Binding var inkColor: Color
    @Binding var inkWidth: CGFloat
    
    var body: some View {
        ZStack {
            if appear && isDrawing {
                VStack {     
                    Image(systemName: "scribble.variable")
                        .font(.system(size: 35, weight: .regular))
                        .foregroundColor(inkColor.opacity(inkOpacity))
                    
                    Slider(value: $inkOpacity, in: 0.1...1) { _ in
                        inkingTool.color = UIColor(inkColor.opacity(inkOpacity))
                    }
                    .tint(inkColor)
                    .frame(width: 100)
                    
                    Divider()
                        .frame(width: 100)
                    
                    Circle()
                        .fill(inkColor)
                        .frame(width: inkWidth, height: inkWidth)
                    
                    Slider(value: $inkWidth, in: inkingTool.inkType.validWidthRange) { _ in
                        inkingTool.width = inkWidth
                    }
                    .tint(inkColor)
                    .frame(width: 100)
                }
                .padding(10)
                .background(.gray.gradient.opacity(0.2))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(25)
            }
        }
        .onAppear {
            withAnimation(.spring()) { 
                appear.toggle()
            }
        }
    }
}

