import SwiftUI
import PencilKit

struct ToolSelector: View {
    
    @State var appear = false
    
    @Binding var inkingTool: PKInkingTool
    @Binding var inkColor: Color
    @Binding var isDrawing: Bool
    @Binding var usingLassoTool: Bool
    @Binding var isRulerActive: Bool
    
    var body: some View {
        ZStack {
            if appear {
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Pencil(color: inkColor)
                            .onTapGesture {
                                withAnimation(.spring()) { 
                                    inkingTool.inkType = .pencil
                                    isDrawing = true
                                    usingLassoTool = false
                                }
                            }
                            .offset(x: inkingTool.inkType == .pencil && isDrawing && !usingLassoTool ? -95 : -155)
                            .grayscale(inkingTool.inkType == .pencil && isDrawing && !usingLassoTool ? 0 : 1)
                        
                        Pen(color: inkColor)
                            .onTapGesture {
                                withAnimation(.spring()) { 
                                    inkingTool.inkType = .pen
                                    isDrawing = true
                                    usingLassoTool = false
                                }
                            }
                            .offset(x: inkingTool.inkType == .pen && isDrawing && !usingLassoTool ? -225 : -265)
                            .grayscale(inkingTool.inkType == .pen && isDrawing && !usingLassoTool ? 0 : 1)
                            
                        
                        Marker(color: inkColor)
                            .onTapGesture {
                                withAnimation(.spring()) { 
                                    inkingTool.inkType = .marker
                                    isDrawing = true
                                    usingLassoTool = false
                                }
                            }
                            .offset(x: inkingTool.inkType == .marker && !usingLassoTool && isDrawing ? -50 : -100)
                            .grayscale(inkingTool.inkType == .marker && isDrawing && !usingLassoTool ? 0 : 1)
                        
                        Image("Scissors")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.angularGradient(colors: usingLassoTool ? [.white, .gray] : [.gray], center: .center, startAngle: .degrees(0), endAngle: .degrees(45)))
                            .frame(width: 200, height: 120)
                            .scaledToFit()
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    usingLassoTool.toggle()
                                }
                            }
                            .offset(x: usingLassoTool ? -60 : -120)
                        
                        Image("Ruler")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isRulerActive ? .yellow : .gray)
                            .frame(width: 200, height: 120)
                            .scaledToFit()
                            .cornerRadius(18)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    isRulerActive.toggle()
                                }
                            }
                            .offset(x: isRulerActive ? -65 : -120)
                            
                        Image("Eraser")
                            .resizable()
                            .grayscale(!isDrawing && !usingLassoTool ? 0 : 1)
                            .scaledToFit()
                            .frame(height: 120)
                            .onTapGesture {
                                withAnimation(.spring()) { 
                                    isDrawing.toggle()
                                    usingLassoTool = false
                                }
                            }
                            .offset(x: !isDrawing && !usingLassoTool ? -30 : -85)
                    }
                    .scaleEffect(0.7, anchor: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .pencilSupport(isDrawing: $isDrawing, usingLassoTool: $usingLassoTool)
        .onAppear {
            withAnimation(.spring()) {
                appear.toggle()
            }
        }
    }
}

struct ToolSelector_Previews: PreviewProvider {
    static var previews: some View {
        ToolSelector(inkingTool: .constant(PKInkingTool(.pen, color: .systemBlue, width: 10)), inkColor: .constant(.blue), isDrawing: .constant(true), usingLassoTool: .constant(false), isRulerActive: .constant(false))
    }
}
