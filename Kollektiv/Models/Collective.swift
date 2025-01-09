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
    var roomDistributionManager: RoomDistributionManager
    
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
        self.roomDistributionManager = RoomDistributionManager()
    }
    
    private static func generateInviteCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in letters.randomElement()! })
    }
    
    mutating func generateNewInviteCode() {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        self.inviteCode = String((0..<8).map { _ in characters.randomElement()! })
    }
    
    mutating func distributeRooms() {
        roomDistributionManager.distributeRooms(rooms: rooms, users: members)
    }
    
    mutating func rotateRoomAssignments() {
        roomDistributionManager.rotateAssignments(users: members)
    }
    
    func getCurrentAssignments(for userId: String) -> [Room] {
        roomDistributionManager.getCurrentAssignments(for: userId)
    }
    
    func getUpcomingAssignments(for userId: String) -> [(weekNumber: Int, rooms: [Room])] {
        roomDistributionManager.getUpcomingAssignments(for: userId)
    }
    
    mutating func generateSchedule(weeks: Int = 12) {
        let schedule = roomDistributionManager.generateSchedule(
            rooms: rooms,
            users: members,
            weeks: weeks
        )
        
        // You can store or process the schedule here
        print("Generated schedule for \(weeks) weeks")
        print("Total assignments: \(schedule.reduce(0) { $0 + $1.totalRooms })")
    }
} 