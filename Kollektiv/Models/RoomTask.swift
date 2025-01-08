import Foundation

struct RoomTask: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var isCompleted: Bool = false
    var lastCompletedDate: Date?
    
    // For common room types, we'll provide default tasks
    static func defaultTasks(for roomType: RoomType) -> [RoomTask] {
        switch roomType {
        case .kitchen:
            return [
                RoomTask(name: "Wipe counters and stovetop"),
                RoomTask(name: "Clean sink"),
                RoomTask(name: "Take out trash"),
                RoomTask(name: "Sweep and mop floor"),
                RoomTask(name: "Clean microwave")
            ]
        case .bathroom:
            return [
                RoomTask(name: "Clean toilet"),
                RoomTask(name: "Clean shower/bathtub"),
                RoomTask(name: "Clean sink and mirror"),
                RoomTask(name: "Sweep and mop floor"),
                RoomTask(name: "Empty trash")
            ]
        case .livingRoom:
            return [
                RoomTask(name: "Vacuum floor"),
                RoomTask(name: "Dust furniture"),
                RoomTask(name: "Clean windows"),
                RoomTask(name: "Organize common items")
            ]
        case .custom:
            return []
        }
    }
}

enum RoomType: String, CaseIterable {
    case kitchen = "Kitchen"
    case bathroom = "Bathroom"
    case livingRoom = "Living Room"
    case custom = "Custom"
} 