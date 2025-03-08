import SwiftUI

struct LayersPanel: View {
    
    let canva: Canva
    @Binding var currentLayer: UUID
    @Binding var drawingOnCanva: Bool
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.displayScale) var displayScale
    
    @State var showingLayers = false
    @State var appear = false
    @State var editingName = false
    @State var name = ""
    @State var update = false
    
    var body: some View {
        ZStack {
            if appear {
                LazyVStack(alignment: .trailing) {
                    HStack {                        
                        Button {
                            withAnimation(.spring()) { 
                                showingLayers.toggle()
                            }
                        } label: {
                            Label(
                                title: { 
                                    Image(systemName: "chevron.down") 
                                        .rotationEffect(.degrees(showingLayers ? 180 : 0))
                                },
                                icon: {  
                                    Label("Layers", systemImage: "square.3.layers.3d")
                                        .bold()
                                }
                            )
                            .font(.title3)
                            .labelStyle(.titleAndIcon)
                        }
                        
                        showingLayers ? Spacer() : nil
                        
                        Button(action: addLayer) {
                            Label("Add Layer", systemImage: "plus.circle.fill")
                                .font(.title3.bold())
                                .hoverEffect(.lift)
                        }
                    }
                    
                    if showingLayers {
                        ScrollView(showsIndicators: false) {
                            LazyVStack {
                                ForEach(canva.layersArray) { layer in
                                    Menu {
                                        Button {
                                            withAnimation(.spring()) {
                                                currentLayer = layer.id
                                                editingName = true
                                            }
                                        } label: {
                                            Label("Rename", systemImage: "pencil")
                                        }
                                        
                                        Button {
                                            withAnimation(.spring()) {
                                                layer.isVisible.toggle()
                                                try? self.context.save()
                                                let aux = currentLayer
                                                currentLayer = UUID()
                                                currentLayer = aux
                                                update.toggle()
                                            }
                                        } label: {
                                            if layer.isVisible {
                                                Label("Hide Layer", systemImage: "eye.slash")
                                            } else {
                                                Label("Show Layer", systemImage: "eye")
                                            }
                                        }
                                        
                                        if layer.id != canva.layersArray.first!.id {
                                            Button {
                                                moveLayerUp(layer: layer)
                                            } label: {
                                                Label("Move Layer Up", systemImage: "square.2.layers.3d.top.filled")
                                            }
                                        }
                                         
                                        if layer.id != canva.layersArray.last!.id {
                                            Button {
                                                moveLayerDown(layer: layer)
                                            } label: {
                                                Label("Move Layer Down", systemImage: "square.2.layers.3d.bottom.filled")
                                            }
                                        }
                                        
                                        Menu {
                                            Text("This action cannot be undone.")
                                            
                                            Button(role: .destructive) {
                                                deleteLayerAndChangePositions(layer: layer)
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
                                        VStack(alignment: .trailing) {
                                            if layer.isVisible {
                                                Image(uiImage: PKCanvasExport(layer: layer, displayScale: displayScale))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 175, height: 50)
                                                    .background(.secondary.opacity(layer.id == currentLayer ? 0.5 : 0.0))
                                                    .cornerRadius(8)
                                            }
                                            
                                            Text(layer.wrappedName)
                                                .font(.bodoni(layer.id == currentLayer ? .black : .bold, size: 18))
                                                .foregroundColor(.secondary) 
                                                .multilineTextAlignment(.trailing)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                        .padding(.trailing, 5)
                                    } primaryAction: {
                                        currentLayer = layer.id
                                    }
                                    
                                    Divider()
                                        .frame(width: 170)
                                }
                            }
                        }
                        .transition(.opacity)
                    }
                }
                .foregroundColor(.primary)
                .labelStyle(.iconOnly)
                .padding(15)
                .background(.gray.gradient.opacity(0.2))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .frame(width: showingLayers ? 200 : 120)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, showingLayers ? 25 : 25)
                .padding(.trailing, showingLayers ? 30 : -5)
                .transition(.move(edge: .trailing))
                .padding(.bottom, showingLayers ? 35: 0)
            }
        }
        .padding(.trailing, showingLayers ? 0 : 30)
        .alert("Change Layer Name", isPresented: $editingName) {
            TextField("Layer Name...", text: $name)
            
            Button("Cancel", role: .cancel) {
                editingName = false
                name = ""
            }
            
            Button("OK") {
                canva.layersArray.first { $0.id == currentLayer }!.name = name
                try? self.context.save()
                name = ""
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)) { _ in 
            showingLayers.toggle()
            showingLayers.toggle()
            update.toggle()
        }
        .onAppear {
            withAnimation(.spring()) {
                appear.toggle()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring()) {
                        showingLayers.toggle()
                    }
                } 
            }
        }
        .onChange(of: drawingOnCanva) { newValue in
            if newValue == false {
                withAnimation(.spring()) {
                    showingLayers = false
                    appear = false
                }
            }
        }
    }
    
    func moveLayerUp(layer: Layer) {
        withAnimation(.spring()) {
            let index = canva.layersArray.firstIndex(of: layer)!
            let layerUp = canva.layersArray[index - 1]
            
            layer.position -= 1
            layerUp.position += 1
            
            try? self.context.save()
            update.toggle()
        }
        
        currentLayer = UUID()
        currentLayer = layer.id
    }
    
    func moveLayerDown(layer: Layer) {
        withAnimation(.spring()) { 
            let index = canva.layersArray.firstIndex(of: layer)!
            let layerDown = canva.layersArray[index + 1]
            
            layer.position += 1
            layerDown.position -= 1
            
            try? self.context.save()
            update.toggle()
        }
        
        currentLayer = UUID()
        currentLayer = layer.id
    }
    
    func addLayer() {
        withAnimation(.spring()) { 
            let newLayer = Layer(context: context)
            newLayer.id = UUID()
            newLayer.name = "Layer \(canva.layersArray.count + 1)"
            newLayer.canva = canva
            newLayer.position = 0
            newLayer.isVisible = true
            
            for layer in canva.layersArray.filter({ layer in
                layer.id != newLayer.id
            }) {
                layer.position = layer.position + 1
            }
            
            try? self.context.save()
            currentLayer = newLayer.id
            
            showingLayers = true
        }
    }
    
    func deleteLayerAndChangePositions(layer: Layer) {
        var sorted = canva.layersArray
        let index = sorted.firstIndex(of: layer)!
        
        withAnimation(.spring()) { 
            for layer in sorted.dropFirst(index + 1) {
                layer.position = layer.position - 1
            }
            
            self.context.delete(layer)
            try? self.context.save()
            
            if canva.layersArray.isEmpty {
                addLayer()
            } else {
                sorted = canva.layersArray
                
                if index == canva.layersArray.count {
                    currentLayer = sorted.last!.id
                } else {
                    currentLayer = sorted[index].id
                }
            }
        }
    }
}
