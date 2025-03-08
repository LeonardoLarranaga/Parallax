import SwiftUI
import PencilKit

struct HomeGridItem: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.displayScale) var displayScale
    
    let canva: Canva
    var estimatedSize: String {
        var data = Data()
        
        data.append(canva.wrappedTitle.data(using: .unicode, allowLossyConversion: false)!)
        
        for layer in canva.layersArray {
            data.append(layer.wrappedData)
            data.append(layer.wrappedName.data(using: .unicode, allowLossyConversion: false)!)
        }
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        
        return formatter.string(fromByteCount: Int64(data.count))
    }
    
    @Binding var currentCanva: UUID
    @Binding var drawingOnCanva: Bool
    @State var hovering = false
    @State var update = false
    @State var changeName = false
    @State var name = ""
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                
                Image(uiImage: PKCanvasExport(canva: canva, displayScale: displayScale))
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: 275, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .secondary.opacity(hovering ? 0.6 : 0.4), radius: hovering ? 35 : 25, x: 0, y: 0)
            .rotation3DEffect(.degrees(hovering ? 5 : 0), axis: (x: 5, y: 5, z: 0))
            .scaleEffect(hovering ? 1.1 : 1.0)
            .overlay {
                Menu {
                    Text("Estimated size: \(estimatedSize)")
                    
                    Text("^[\(canva.layersArray.count) layer](inflect: true)")
                    
                    Text("Last opened: \(canva.wrappedLastOpened.formatted(date: .complete, time: .shortened))")
                    
                    Button {
                        name = canva.wrappedTitle
                        changeName.toggle()
                    } label: {
                        Label("Change Title", systemImage: "pencil")
                    }
                    
                    Menu {
                        Text("This action cannot be undone.")
                        
                        Button(role: .destructive) {
                            withAnimation(.spring()) {
                                self.context.delete(canva)
                                try? self.context.save()
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        
                        Button(role: .cancel) {} label: {
                            Label("Cancel", systemImage: "xmark")
                        }
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                } label: {
                    Rectangle()
                        .fill(.clear)
                } primaryAction: {
                    currentCanva = canva.id
                    drawingOnCanva = true
                    update.toggle()
                    
                    canva.lastOpened = .now
                    try? self.context.save()
                }
                .onHover { hover in
                    update = false
                    withAnimation(.spring()) {
                        hovering = hover
                    }
                }
            }
            
            Text(canva.wrappedTitle)
                .font(.bodoni(.bold, size: 22))
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)) { _ in
            update.toggle()
        }
        .alert("Change Title", isPresented: $changeName) {
            TextField("Canva Name...", text: $name)
            
            Button("Cancel", role: .cancel, action: {})
            
            Button("OK") {
                withAnimation { 
                    canva.title = name
                    try? self.context.save()
                }
            }
        }
    }
}
