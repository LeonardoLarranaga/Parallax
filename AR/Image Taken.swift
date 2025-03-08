import SwiftUI

struct ImageTaken: View {
    
    var lastImageTaken: UIImage    
    @State var appear = false
    
    var body: some View {
        ZStack {
            Image(uiImage: lastImageTaken)
                .resizable()
                .scaledToFit()
                .border(lastImageTaken != .init() ? .white : .clear, width: 10)
                .shadow(color: .white.opacity(lastImageTaken != .init() ? 0.5 : 0), radius: 20)
                .scaleEffect(lastImageTaken != .init() ? 0.6 : 1)
                .rotationEffect(.degrees(lastImageTaken == .init() ? 0 : -15))
                .padding()
                .opacity(lastImageTaken == .init() ? 0 : 1)
        }
    }
}
