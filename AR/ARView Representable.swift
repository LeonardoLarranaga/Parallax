import SwiftUI
import RealityKit
import ARKit

struct ARViewRepresentable: UIViewRepresentable {

    @Binding var arView: ARView
    @Binding var images: [UIImage]
    
    func makeUIView(context: Context) -> ARView { 
        return arView
    }
    
    func updateUIView(_ uiArView: ARView, context: Context) {
        for i in 0..<images.count {
            let anchor = AnchorEntity(world: [0.0, 0.0, -Float(i) - 0.5])
            
            do {
                let textureResource = try TextureResource.generate(from: images[i].cgImage!, withName: "Image\(i)", options: .init(semantic: .color, mipmapsMode: .none))
                
                let materialParameter = MaterialParameters.Texture(textureResource)
                
                let resource = MeshResource.generatePlane(width: Float(images[i].size.width) / 1000, depth: 1, cornerRadius: 0)
                
                var material = UnlitMaterial()
                material.color = .init(tint: .white.withAlphaComponent(0.99), texture: materialParameter)
                material.opacityThreshold = 0.5
                
                let planeEntity = ModelEntity(mesh: resource, materials: [material])
                planeEntity.transform = Transform(pitch: .pi / 2, yaw: .pi , roll: .pi)
                
                anchor.addChild(planeEntity, preservingWorldTransform: false)
                
                arView.scene.addAnchor(anchor)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
