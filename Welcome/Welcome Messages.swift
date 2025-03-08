import SwiftUI

struct WelcomeMessages: View {
    
    let messages = ["Hi! 👋", "I'm Leonardo.", "This is my  Swift Student Challenge Submission.", "Grab your  Pencil, let's get digital art into the real world."]
    
    @State var messagesOnScreen = 0
    @Binding var showingTitle: Bool
    
    var body: some View {
        VStack(alignment: .trailing) {
            ForEach(0..<messages.count, id: \.self) { message in
                if message <= messagesOnScreen {
                    Text(messages[message])
                        .font(.bodoni(.bold, size: 28))
                        .foregroundStyle(.linearGradient(colors: message == messages.count - 1 ? [.blue, .cyan] : [.primary], startPoint: .leading, endPoint: .trailing))
                        .multilineTextAlignment(.trailing)
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(12)
                        .padding(.vertical)
                }
            }
            
            if messages.count == messagesOnScreen {
                Button("Let's go!") {
                    withAnimation(.easeOut) { 
                        showingTitle = true
                    }
                }
                .font(.bodoni(.semibold, size: 18))
                .padding(10)
                .background(.blue.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
                if messagesOnScreen != messages.count {
                    withAnimation(.easeIn) { 
                        messagesOnScreen += 1
                    }
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}

struct WelcomeMessages_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeMessages(showingTitle: .constant(false))
    }
}
