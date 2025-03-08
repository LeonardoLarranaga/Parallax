import SwiftUI
import PencilKit

struct ColorSlideshow: View {
    
    let SwiftUIColors: [Color] = [.blue, .purple, .indigo, .cyan, .mint, .green, .yellow, .orange, .pink, .red, .brown, .gray, .black]
    
    @Binding var inkingTool: PKInkingTool
    @Binding var inkColor: Color
    @Binding var inkOpacity: CGFloat
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom) {
                ForEach(SwiftUIColors, id: \.self) { color in
                    ColorSquare(color: color)
                }
                
                CustomColor()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.leading, 165)
        .padding(.bottom, 25)        
    }
    
    @ViewBuilder
    func ColorSquare(color: Color) -> some View {
        let isSelectedColor = inkColor == color
        RoundedRectangle(cornerRadius: 12)
            .fill(color)
            .frame(width: isSelectedColor ? 60 : 55, height: isSelectedColor ? 60 : 55)
            .onTapGesture {
                withAnimation(.spring()) {
                    inkingTool = PKInkingTool(inkingTool.inkType, color: UIColor(color.opacity(inkOpacity)), width: inkingTool.width)
                    inkColor = color
                }
            }
    }
    
    @State var customColor = Color.blue
    @ViewBuilder
    func CustomColor() -> some View {
        let inkColorIsSwiftUI = SwiftUIColors.contains(inkColor)
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.angularGradient(colors: SwiftUIColors.dropLast(3), center: .center, startAngle: .zero, endAngle: .degrees(360)))
                      
            ColorPicker("", selection: $customColor, supportsOpacity: false)
                .labelsHidden()
                .onChange(of: customColor, perform: { value in
                    withAnimation(.spring()) { 
                        inkColor = customColor
                        inkingTool = PKInkingTool(inkingTool.inkType, color: UIColor(inkColor.opacity(inkOpacity)), width: inkingTool.width)
                    }
                })
        }
        .frame(width: inkColorIsSwiftUI ? 55 : 60, height: inkColorIsSwiftUI ? 55 : 60)
    }
    
}
