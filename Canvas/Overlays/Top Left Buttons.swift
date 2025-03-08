import SwiftUI

struct TopLeftButtons: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.undoManager) var undoManager
    @Environment(\.displayScale) var displayScale
    
    @Binding var drawingOnCanva: Bool
    
    let canva: Canva
    
    @ObservedObject var coreMotionManager: CoreMotionManager
    
    @Binding var geometrySize: CGSize
    @Binding var zoom: CGFloat
    @Binding var offset: CGSize
    
    @State var uiImage = UIImage.init()
    @State var image = Image(systemName: "pencil")
    @State var exported = false
    @State var viewingAR = false
    @State var fileURL = URL(string: "https://developer.apple.com/wwdc23/swift-student-challenge/")!
    @State var exportedFile = false
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    drawingOnCanva = false
                }
            } label: {
                Label("Back", systemImage: "xmark")
            }
            
            if geometrySize.width == fullScreen.width && geometrySize.width > geometrySize.height {
                divider
                
                Button(action: coreMotionManager.toggle) {
                    Label("Parallax", systemImage: "move.3d")
                        .parallax(coreMotionManager, degreesMultiplier: 0, multiplier3D: (x: 20, y: 30, z: 30), anchorZMultiplier: 10, perspectiveMultiplier: 20, xOffsetMultiplier: 0, yOffsetMultiplier: 0)
                }
                
                divider
                
                Button {
                    viewingAR.toggle()
                } label: {
                    Label("View in AR", systemImage: "camera.metering.matrix")
                }
                
                divider
                
                if zoom != 0.7 || offset != .zero {
                    HStack {
                        Button {
                            withAnimation(.spring()) {
                                zoom = 0.7
                                offset = .zero
                            }
                        } label: {
                            Label("Reset Zoom", systemImage: "1.magnifyingglass")
                        }
                        
                        divider
                    }
                    .transition(.opacity)
                }
                
                Button {
                    if undoManager?.canUndo ?? false {
                        undoManager?.undo()
                        try? self.context.save()
                    }
                } label: {
                    Label("Undo", systemImage: "arrowshape.turn.up.backward")
                }
                .keyboardShortcut("z", modifiers: .command)
                
                Button {
                    if undoManager?.canRedo ?? false {
                        undoManager?.redo()
                        try? self.context.save()
                    }
                } label: {
                    Label("Undo", systemImage: "arrowshape.turn.up.right")
                }
                .keyboardShortcut("z", modifiers: [.command, .shift])
                
                divider
                
                Menu {
                    Button {
                        uiImage = PKCanvasExport(canva: canva, displayScale: displayScale)
                    } label: {
                        Label("Image", systemImage: "photo.fill")
                    }
                    
                    Button {
                        fileURL = createFile(canva: canva)
                    } label: {
                        Label("Parallax Canva File", systemImage: "paintpalette.fill")
                    }
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
        .foregroundColor(.blue)
        .labelStyle(.iconOnly)
        .font(.title3)
        .padding(10)
        .background(.gray.gradient.opacity(0.2))
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(25)
        .transition(.move(edge: .top))
        .sheet(isPresented: $exported) {
            ShareView
        }
        .onChange(of: uiImage.size) { newValue in
            image = Image(uiImage: uiImage)
            exported = uiImage != .init()
        }
        .fullScreenCover(isPresented: $viewingAR) {
            ARComposer(canva: canva)
        }
        .onAppear {
            context.undoManager = undoManager
        }
        .onChange(of: fileURL) { _ in
            exportedFile.toggle()
        }
        .sheet(isPresented: $exportedFile) {
            ShareSheet(activityItems: [fileURL])
        }
    }
    
    
    
    var divider: some View {
        Divider()
            .frame(height: 20)
    }
    
    var ShareView: some View {
        NavigationStack {
            VStack {
                image
                    .resizable()
                    .scaledToFit()
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: .secondary.opacity(0.2), radius: 25, x: 0, y: 0)
                    .padding(55)
                
                ShareLink(item: image, preview: SharePreview(canva.wrappedTitle, image: image)) { 
                    Text("Share")
                        .foregroundColor(.white)
                        .font(.bodoni(.extraBold, size: 24))
                        .frame(width: 250, height: 55)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.linearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing))
                        }
                        .hoverEffect(.highlight)
                }
            }
            .toolbar {
                Button("Done") {
                    exported = false
                }
                .font(.bodoni(.extraBold, size: 18))
            }
            .onAppear {
                uiImage = PKCanvasExport(canva: canva, displayScale: displayScale)
            }
            .onDisappear {
                uiImage = .init()
                image = Image(systemName: "pencil")
            }
        }
    }
}
