import SwiftUI

struct ContentView: View {
    @AppStorage("FinishedWelcome") var finishedWelcome = false
    var body: some View {
        ZStack {
            Home()
            
            if finishedWelcome == false {
                FullWelcome()
                    .transition(.opacity)    
            }
        }
    }
}
