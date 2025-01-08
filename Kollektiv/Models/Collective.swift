import Foundation

struct Collective: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var members: [User]
    var rooms: [Room]
    var pendingInvitations: [Invitation]
    var createdBy: String
    var createdDate: Date
    
    init(name: String, description: String = "", createdBy: String) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.members = []
        self.rooms = []
        self.pendingInvitations = []
        self.createdBy = createdBy
        self.createdDate = Date()
    }
} 