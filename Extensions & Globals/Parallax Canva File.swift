import SwiftUI
import UniformTypeIdentifiers
import CoreData
import PencilKit

extension UTType {
    static var parallaxCanva: UTType { UTType(filenameExtension: "parallaxcanva", conformingTo: .data)!
    }
}

func importCanva(_ fileURL: URL, context: NSManagedObjectContext, isBundle: Bool) {
    do {
        if isBundle == false {
            guard fileURL.startAccessingSecurityScopedResource() else { return }
        }
        
        let data = try Data(contentsOf: fileURL, options: .alwaysMapped)
        
        guard let canvaDictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any] else {
            return
        }
        
        let canva = Canva(context: context)
        canva.id = UUID()
        canva.title = canvaDictionary["title"] as? String ?? "ERROR"
        canva.lastOpened = canvaDictionary["lastOpened"] as? Date ?? .now
        
        if let layerDictionaries = canvaDictionary["layers"] as? [[String: Any]] {
            for layerDictionary in layerDictionaries {
                let layer = Layer(context: context)
                layer.id = UUID()
                layer.name = layerDictionary["name"] as? String ?? "ERROR"
                layer.data = layerDictionary["data"] as? Data ?? Data()
                layer.position = layerDictionary["position"] as? Int16 ?? 0
                layer.isVisible = layerDictionary["isVisible"] as? Bool ?? true
                layer.canva = canva
            }
        }
        
        try? context.save()
        
        fileURL.stopAccessingSecurityScopedResource()
    } catch {
        print(error.localizedDescription)
    }
}

func createFile(canva: Canva) -> URL {
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(canva.wrappedTitle).parallaxcanva")
    
    var canvaDictionary: [String: Any] = [:]
    canvaDictionary["title"] = canva.wrappedTitle
    canvaDictionary["lastOpened"] = canva.wrappedLastOpened
    
    var layerDictionaries: [[String: Any]] = []
    
    for layer in canva.layersArray {
        var layerDict: [String: Any] = [:]
        layerDict["name"] = layer.wrappedName
        layerDict["data"] = layer.wrappedData
        layerDict["position"] = layer.position
        layerDict["isVisible"] = layer.isVisible
        layerDictionaries.append(layerDict)
    }
    
    canvaDictionary["layers"] = layerDictionaries
    
    let data = try! NSKeyedArchiver.archivedData(withRootObject: canvaDictionary, requiringSecureCoding: false)
    
    try! data.write(to: fileURL)
    
    return fileURL
}

func importPreexistingCanvas(context: NSManagedObjectContext) {
    let undrawnSun = Bundle.main.url(forResource: "Undrawn Sun", withExtension: "parallaxcanva")!
    
    importCanva(undrawnSun, context: context, isBundle: true)
    
    let blueSpectrum = Bundle.main.url(forResource: "Blue Spectrum Pattern", withExtension: "parallaxcanva")!
    
    importCanva(blueSpectrum, context: context, isBundle: true)
} 
