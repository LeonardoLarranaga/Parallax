import CoreData

class Persistence {
    static let shared = Persistence()

    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        let canvaEntity = NSEntityDescription()
        canvaEntity.name = "Canva"
        canvaEntity.managedObjectClassName = "Canva"
        canvaEntity.properties = [
            Attribute("id", type: .uuid),
            Attribute("title", type: .string),
            Attribute("lastOpened", type: .date)
        ]
        
        let layerEntity = NSEntityDescription()
        layerEntity.name = "Layer"
        layerEntity.managedObjectClassName = "Layer"
        layerEntity.properties = [
            Attribute("id", type: .uuid),
            Attribute("name", type: .string),
            Attribute("data", type: .binaryData),
            Attribute("position", type: .integer16),
            Attribute("isVisible", type: .boolean)
        ]
        
        let layersRelationship = NSRelationshipDescription()
        layersRelationship.name = "layers"
        layersRelationship.destinationEntity = layerEntity
        layersRelationship.maxCount = 0
        
        let canvaRelationship = NSRelationshipDescription()
        canvaRelationship.name = "canva"
        canvaRelationship.destinationEntity = canvaEntity
        canvaRelationship.maxCount = 1
        
        layersRelationship.inverseRelationship = canvaRelationship
        canvaRelationship.inverseRelationship = layersRelationship
        
        canvaEntity.properties.append(layersRelationship)
        layerEntity.properties.append(canvaRelationship)
        
        let model = NSManagedObjectModel()
        model.entities = [canvaEntity, layerEntity]
        
        let container = NSPersistentContainer(name: "Parallax", managedObjectModel: model)
        
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed with: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        self.container = container
    }
}

func Attribute(_ name: String, type: NSAttributeDescription.AttributeType) -> NSAttributeDescription {
    let attribute = NSAttributeDescription()
    attribute.name = name
    attribute.type = type
    return attribute
}
