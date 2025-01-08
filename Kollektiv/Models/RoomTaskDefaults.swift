import Foundation

extension RoomTask {
    static func defaultTasks(for roomType: RoomType) -> [RoomTask] {
        switch roomType {
        case .kitchen:
            return [
                RoomTask(name: "Wipe counters and stovetop", priority: .high),
                RoomTask(name: "Clean sink", priority: .medium),
                RoomTask(name: "Take out trash", priority: .high),
                RoomTask(name: "Sweep and mop floor", priority: .medium),
                RoomTask(name: "Clean microwave", priority: .low)
            ]
        case .bathroom:
            return [
                RoomTask(name: "Clean toilet", priority: .high),
                RoomTask(name: "Clean shower/bathtub", priority: .high),
                RoomTask(name: "Clean sink and mirror", priority: .medium),
                RoomTask(name: "Sweep and mop floor", priority: .medium),
                RoomTask(name: "Empty trash", priority: .low)
            ]
        case .livingRoom:
            return [
                RoomTask(name: "Vacuum floor", priority: .high),
                RoomTask(name: "Dust furniture", priority: .medium),
                RoomTask(name: "Clean windows", priority: .low),
                RoomTask(name: "Organize common items", priority: .low)
            ]
        case .custom:
            return []
        }
    }
} 