import Foundation

struct Collective: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var members: [User]
    var rooms: [Room]
    var createdBy: String // User ID
    var createdDate: Date
    
    init(name: String, description: String = "", createdBy: String) {
        self.name = name
        self.description = description
        self.members = []
        self.rooms = []
        self.createdBy = createdBy
        self.createdDate = Date()
    }
} 