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
    private(set) var roomDistribution: [String: [Room]]
    
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
        self.roomDistribution = [:]
    }
    
    private static func generateInviteCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in letters.randomElement()! })
    }
    
    mutating func generateNewInviteCode() {
        // Generate a new 8-character alphanumeric code
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        self.inviteCode = String((0..<8).map { _ in
            characters.randomElement()!
        })
    }
    
    mutating func distributeRooms() {
        let manager = RoomDistributionManager()
        self.roomDistribution = manager.distributeRooms(rooms: rooms, users: members)
    }
    
    mutating func rotateRoomAssignments() {
        let manager = RoomDistributionManager()
        manager.assignments = self.roomDistribution
        manager.rotateAssignments()
        self.roomDistribution = manager.assignments
    }
    
    func getRoomsAssigned(to userId: String) -> [Room] {
        return roomDistribution[userId] ?? []
    }
} 