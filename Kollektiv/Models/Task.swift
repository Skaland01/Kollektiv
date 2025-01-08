import Foundation

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var assignedTo: String
    var dueDate: Date
    var dateCreated: Date
    var category: TaskCategory
    var priority: Priority
    var isCompleted: Bool
    var completedDate: Date?
    
    init(
        title: String,
        description: String = "",
        assignedTo: String,
        dueDate: Date,
        category: TaskCategory,
        priority: Priority = .normal,
        isCompleted: Bool = false,
        completedDate: Date? = nil
    ) {
        self.title = title
        self.description = description
        self.assignedTo = assignedTo
        self.dueDate = dueDate
        self.dateCreated = Date()
        self.category = category
        self.priority = priority
        self.isCompleted = isCompleted
        self.completedDate = completedDate
    }
    
    enum Priority: String, Comparable {
        case high = "High"
        case normal = "Normal"
        case low = "Low"
        
        static func < (lhs: Priority, rhs: Priority) -> Bool {
            let order: [Priority] = [.low, .normal, .high]
            return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
        }
    }
}

// Add some sample tasks for testing
extension Task {
    static var sampleTasks: [Task] = [
        Task(
            title: "Clean Kitchen",
            description: "Deep clean all surfaces",
            assignedTo: "currentUser",
            dueDate: Date().addingTimeInterval(86400), // Tomorrow
            category: .washing,
            priority: .high
        ),
        Task(
            title: "Vacuum Living Room",
            description: "Including under furniture",
            assignedTo: "currentUser",
            dueDate: Date().addingTimeInterval(172800), // Day after tomorrow
            category: .cleaning,
            priority: .normal
        ),
        Task(
            title: "Buy Groceries",
            description: "Check the shared list",
            assignedTo: "currentUser",
            dueDate: Date(),
            category: .groceries,
            priority: .low
        )
    ]
}