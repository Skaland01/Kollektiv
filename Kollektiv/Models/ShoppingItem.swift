import Foundation

struct ShoppingItem: Identifiable {
    let id = UUID()
    var name: String
    var addedBy: String
    var isCompleted: Bool
    var dateAdded: Date
}