import SwiftUI

struct FullWelcome: View {
    
    @State var showingTitle = false
    @State var showingMessages = true
    
    var body: some View {
        ZStack {
            if showingMessages {
                WelcomeMessages(showingTitle: $showingTitle)
            }
            
            if showingTitle {
                ParallaxTitle()
                    .opacity(showingMessages ? 0 : 1)
            }
        }
        .onChange(of: showingTitle) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeInOut) { 
                        showingMessages = false
                    }
                }
            }
        } 
        .background()
        .edgesIgnoringSafeArea(.all)
    }
}

struct FullWelcome_Previews: PreviewProvider {
    static var previews: some View {
        FullWelcome()
    }
}
