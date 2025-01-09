import Foundation
import SwiftUI

struct RoomTask: Identifiable, Hashable {
    let id: UUID
    var name: String
    var priority: TaskPriority
    var isCompleted: Bool
    var lastCompletedDate: Date?
    
    enum TaskPriority: String, CaseIterable {
        case high = "High"
        case medium = "Medium"
        case low = "Low"
        
        var color: Color {
            switch self {
            case .high: return .red
            case .medium: return .orange
            case .low: return .blue
            }
        }
        
        var icon: String {
            switch self {
            case .high: return "exclamationmark.3"
            case .medium: return "exclamationmark.2"
            case .low: return "exclamationmark"
            }
        }
        
        var displayName: String {
            self.rawValue
        }
    }
    
    init(id: UUID = UUID(), name: String, priority: TaskPriority = .medium, isCompleted: Bool = false, lastCompletedDate: Date? = nil) {
        self.id = id
        self.name = name
        self.priority = priority
        self.isCompleted = isCompleted
        self.lastCompletedDate = lastCompletedDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RoomTask, rhs: RoomTask) -> Bool {
        lhs.id == rhs.id
    }
} 