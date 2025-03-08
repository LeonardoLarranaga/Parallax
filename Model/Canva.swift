import SwiftUI
import CoreData

@objc(Canva)
class Canva: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var title: String?
    @NSManaged var lastOpened: Date?
    @NSManaged var layers: Set<Layer>?
}

extension Canva {
    var wrappedTitle: String {
        title ?? "Canva"
    }
    
    var wrappedLastOpened: Date {
        lastOpened ?? .now
    }
    
    var layersArray: [Layer] {
        Array(layers ?? [])
            .sorted { $0.position < $1.position }
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

enum CodableError: Error {
    case NSManagedObjectNotFound
}
