import SwiftUI
import UniformTypeIdentifiers

struct Home: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @State var currentCanva = UUID()
    @State var importingFile = false
    @State var drawingOnCanva = false
    
    @AppStorage("FirstTime") var firstTime = true
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Canva.lastOpened, ascending: false)]) var canvas: FetchedResults<Canva>
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "BodoniModa-ExtraBold", size: 32)!, .foregroundColor: UIColor(.blue)]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "BodoniModa-ExtraBold", size: 22)!, .foregroundColor: UIColor(.blue)]
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(300)), count: Int(geometry.size.width / 300)), spacing: 35) {
                        ForEach(canvas) { canva in
                            HomeGridItem(canva: canva, currentCanva: $currentCanva, drawingOnCanva: $drawingOnCanva)
                        }
                    }
                    .padding(.top)
                }
                .scrollContentBackground(.hidden)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .walkthrough(0, messageAlignment: .topTrailing, message: Text("These are your canvas.\nYou can tap them to open them.\nOr touch and hold to see more information about them."), offset: (x: 0, y: 0))
            }
            .background {
                Color(uiColor: colorScheme == .light ? UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00) : UIColor(red: 0.13, green: 0.13, blue: 0.14, alpha: 1.00))
                    .edgesIgnoringSafeArea(.all)
            }
            .disabled(drawingOnCanva)
            .navigationTitle("Canvas")
            .toolbar {
                Menu {
                    Button(action: createCanva) {
                        Label("New Canva", systemImage: "rectangle.center.inset.filled.badge.plus")
                    }
                    
                    Button { importingFile.toggle() } label: {
                        Label("Import Canva", systemImage: "arrow.down.doc")
                    }
                } label: {
                    Image(systemName: "rectangle.center.inset.filled.badge.plus")
                        .foregroundColor(.blue)
                        .font(.title3.bold())
                }
            }   
            .walkthrough(1, messageAlignment: .topTrailing, message: Text(Image(systemName: "rectangle.center.inset.filled.badge.plus")).foregroundColor(.blue) + Text(" can create a new Parallax Canva;\nor import an existing one with a ") + Text(".parallaxcanva").font(.system(.body, design: .monospaced, weight: .regular)) + Text(" file. Tap a preexisting one to continue."), offset: (x: 15, y: -fullScreen.height * 0.1 + 55 ))
        }
        .navigationViewStyle(.stack)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            ZStack {
                if canvas.isEmpty {
                    VStack {
                        Image(systemName: "rectangle.dashed")
                            .font(.system(size: 85))
                            .foregroundColor(.blue)
                        
                        (Text("It looks like you don't any canvas created. Tap ") + Text(Image(systemName: "rectangle.center.inset.filled.badge.plus")).foregroundColor(.blue) + Text(" to create one."))
                            .font(.bodoni(.extraBold, size: 24))
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                
                if drawingOnCanva {
                    DrawingCanvas(canva: canvas.first(where: {$0.id == currentCanva})!, drawingOnCanva: $drawingOnCanva)
                }
            }
        }
        .fileImporter(isPresented: $importingFile, allowedContentTypes: [.parallaxCanva]) { result in   
            importCanva(try! result.get(), context: self.context, isBundle: false)
        }
        .onAppear {
            if firstTime {
                importPreexistingCanvas(context: self.context)
                firstTime = false
            }
        }
    }
    
    func createCanva() {
        let canva = Canva(context: self.context)
        canva.title = "New Canva \(canvas.count + 1)"
        canva.id = UUID()
        canva.lastOpened = .now
        
        let firstLayer = Layer(context: self.context)
        firstLayer.id = UUID()
        firstLayer.name = "Layer 1"
        firstLayer.data = Data()
        firstLayer.position = 0
        firstLayer.isVisible = true
        firstLayer.canva = canva
        
        try? self.context.save()
        
        currentCanva = canva.id
        drawingOnCanva.toggle()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
