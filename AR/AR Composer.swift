import SwiftUI
import RealityKit

struct ARComposer: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.displayScale) var displayScale
    
    let canva: Canva
    @State var arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
    
    @State var images: [UIImage] = []
    @State var appear = false
    @State var uiImagesTaken: [UIImage] = []
    @State var lastImageTaken = UIImage.init()
    
    var body: some View {
        ZStack {
            if appear {
                ARViewRepresentable(arView: $arView, images: $images)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(alignment: .topLeading) {
                        Button(action: dismiss.callAsFunction) {
                            Image(systemName: "xmark")
                                .font(.title2.bold())
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                        }
                        .padding(35)
                    }
                    .overlay {
                        ImageTaken(lastImageTaken: lastImageTaken)
                    }
                    .overlay(alignment: .bottom) {
                        Button(action: snapshot) {
                            Image(systemName: "camera.shutter.button.fill")
                                .font(.largeTitle)
                                .padding()
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                        .padding(.bottom, 55)
                    }
                    .transition(.opacity)
                
                RecentImages(uiImagesTaken: $uiImagesTaken)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(55)
            }
            
            if appear == false {
                VStack {
                    ProgressView()
                    
                    Text("Loading AR Drawing...")
                }   
                .font(.bodoni(.extraBold, size: 32))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
                .transition(.opacity)
            }
        }
        .onAppear {
            for layer in canva.layersArray.filter({$0.isVisible}).reversed() {
                images.append(PKCanvasExport(layer: layer, displayScale: displayScale))
            }
            
            withAnimation(.spring()) { 
                appear.toggle()
            }
        }
        .onDisappear { images = [] }
    }
    
    func snapshot() {
        arView.snapshot(saveToHDR: false) { image in
            withAnimation(.spring()) { 
                lastImageTaken = UIImage(data: image!.pngData()!)!
                uiImagesTaken.append(lastImageTaken)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring()) { 
                lastImageTaken = .init()
            }
        }
    }
}
