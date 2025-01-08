import Foundation

enum TaskSortOption: String, CaseIterable {
    case dueDate = "Due Date"
    case priority = "Priority"
    case name = "Name"
    case dateCreated = "Date Created"
    
    var icon: String {
        switch self {
        case .dueDate: return "calendar"
        case .priority: return "exclamationmark.triangle"
        case .name: return "textformat"
        case .dateCreated: return "clock"
        }
    }
} 