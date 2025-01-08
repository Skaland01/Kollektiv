import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var tasks: [RoomTask]
    @State private var taskName = ""
    @State private var selectedPriority: RoomTask.TaskPriority = .medium
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Task Name", text: $taskName)
                }
                
                Section {
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(RoomTask.TaskPriority.allCases, id: \.self) { priority in
                            Label(priority.rawValue, systemImage: priority.icon)
                                .foregroundColor(priority.color)
                                .tag(priority)
                        }
                    }
                }
                
                Section {
                    Button("Add Task") {
                        addTask()
                    }
                    .disabled(taskName.isEmpty)
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addTask() {
        let task = RoomTask(name: taskName, priority: selectedPriority)
        tasks.append(task)
        dismiss()
    }
} 