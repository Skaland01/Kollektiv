import Foundation

struct Room: Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var type: RoomType
    var tasks: [RoomTask]
    var assignedMembers: [String]
    var lastCleaned: Date?
    var currentAssignment: RoomAssignment?
    
    init(name: String, description: String = "", type: RoomType = .custom) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.type = type
        self.tasks = RoomTask.defaultTasks(for: type)
        self.assignedMembers = []
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Room, rhs: Room) -> Bool {
        lhs.id == rhs.id
    }
}