import CoreData

@objc(Layer)
class Layer: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var name: String?
    @NSManaged var data: Data?
    @NSManaged var position: Int16
    @NSManaged var isVisible: Bool
    @NSManaged var canva: Canva?
}

extension Layer {
    var wrappedName: String {
        name ?? "Layer"
    }
    
    var wrappedData: Data {
        data ?? Data()
    }
}
