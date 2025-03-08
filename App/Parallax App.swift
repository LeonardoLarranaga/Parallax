import SwiftUI

@main
struct ParallaxApp: App {
    
    init() { 
        BodoniFont.registerAllFonts() 
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, Persistence.shared.container.viewContext)
        }
    }
}
