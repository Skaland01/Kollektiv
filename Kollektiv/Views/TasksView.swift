import SwiftUI

struct TasksView: View {
    @State private var tasks: [Task] = []
    @State private var selectedFilter: TaskFilter = .myTasks
    @State private var selectedCategory: TaskCategory = .washing
    @State private var showCategoryPicker = false
    private let currentUserId = "currentUser"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Section (will be static)
                VStack(spacing: 8) {
                    // Title and Category Row
                    HStack {
                        Text("Tasks")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        
                        Spacer()
                        
                        // Category Dropdown Menu
                        Menu {
                            ForEach(TaskCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    HStack {
                                        Label(category.rawValue, systemImage: category.icon)
                                        if category == selectedCategory {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: selectedCategory.icon)
                                Image(systemName: "chevron.down")
                                    .font(.caption2)
                            }
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    // Custom Filter Tabs
                    HStack(spacing: 36) {
                        FilterButton(title: "My Tasks", 
                                   isSelected: selectedFilter == .myTasks) {
                            selectedFilter = .myTasks
                        }
                        
                        FilterButton(title: "All Tasks", 
                                   isSelected: selectedFilter == .allTasks) {
                            selectedFilter = .allTasks
                        }
                        
                        FilterButton(title: "History", 
                                   isSelected: selectedFilter == .history) {
                            selectedFilter = .history
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    
                    // Separator
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 1)
                        .padding(.horizontal)
                }
                .background(Color(.systemBackground))
                
                // Task List
                List {
                    if selectedFilter != .history {
                        ForEach(filteredTasks) { task in
                            TaskRow(task: task, showAssignee: selectedFilter == .allTasks)
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        markTaskComplete(task)
                                    } label: {
                                        Label("Complete", systemImage: "checkmark.circle")
                                    }
                                    .tint(.green)
                                }
                        }
                    } else {
                        ForEach(completedTasks) { task in
                            CompletedTaskRow(task: task)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationBarHidden(true)
        }
    }
    
    private var filteredTasks: [Task] {
        let categoryTasks = tasks.filter { $0.category == selectedCategory }
        
        switch selectedFilter {
        case .myTasks:
            return categoryTasks.filter { !$0.isCompleted && $0.assignedTo == currentUserId }
        case .allTasks:
            return categoryTasks.filter { !$0.isCompleted }
        case .history:
            return []
        }
    }
    
    private var completedTasks: [Task] {
        return tasks
            .filter { $0.isCompleted && $0.category == selectedCategory }
            .sorted { $0.completedDate ?? Date() > $1.completedDate ?? Date() }
    }
    
    private func markTaskComplete(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted = true
            tasks[index].completedDate = Date()
        }
    }
}

// Task Row View
struct TaskRow: View {
    let task: Task
    let showAssignee: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(task.title)
                    .font(.headline)
                Spacer()
                if showAssignee {
                    Text("@\(task.assignedTo)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(task.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.secondary)
                Text(task.dueDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// Completed Task Row View
struct CompletedTaskRow: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(task.title)
                    .font(.headline)
                Spacer()
                Text("@\(task.assignedTo)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let completedDate = task.completedDate {
                Text("Completed: \(completedDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// Custom Filter Button
struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .accentColor : .gray.opacity(0.6))
                .padding(.vertical, 6)
        }
        .animation(.easeInOut, value: isSelected)
    }
}