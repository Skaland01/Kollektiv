import Foundation

struct Collective: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var members: [User]
    var rooms: [Room]
    var pendingInvitations: [Invitation]
    var inviteCode: String
    var createdBy: String
    var createdDate: Date
    
    init(name: String, description: String = "", createdBy: String) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.members = []
        self.rooms = []
        self.pendingInvitations = []
        self.inviteCode = Self.generateInviteCode()
        self.createdBy = createdBy
        self.createdDate = Date()
    }
    
    private static func generateInviteCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in letters.randomElement()! })
    }
} 