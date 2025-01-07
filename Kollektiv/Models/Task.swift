import Foundation

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var assignedTo: String
    var dueDate: Date
    var isCompleted: Bool
    var completedDate: Date?
    var category: TaskCategory
    
    // Optional priority level for tasks
    var priority: Priority = .normal
    
    enum Priority: String {
        case high = "High"
        case normal = "Normal"
        case low = "Low"
    }
}