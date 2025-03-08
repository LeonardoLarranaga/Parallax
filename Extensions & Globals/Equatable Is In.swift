import SwiftUI

extension Equatable {
    func isIn(_ elements: Self...) -> Bool {
        elements.contains(self)
    }
}
