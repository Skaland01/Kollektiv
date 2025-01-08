import Foundation

struct Room: Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var type: RoomType
    var tasks: [RoomTask]
    var cleaningPeriod: CleaningPeriod
    var lastCleaned: Date?
    var lastCleanedBy: String?
    var isCurrentlyCleaned: Bool {
        tasks.allSatisfy { $0.isCompleted }
    }
    
    init(name: String, description: String = "", type: RoomType = .custom) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.type = type
        self.tasks = RoomTask.defaultTasks(for: type)
        self.cleaningPeriod = .weekly
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Room, rhs: Room) -> Bool {
        lhs.id == rhs.id
    }
    
    mutating func markAsCleaned(by userId: String) {
        lastCleaned = Date()
        lastCleanedBy = userId
    }
    
    mutating func resetTasks() {
        tasks = tasks.map { task in
            var updatedTask = task
            updatedTask.isCompleted = false
            updatedTask.lastCompletedDate = nil
            return updatedTask
        }
    }
}