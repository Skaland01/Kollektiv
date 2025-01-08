import SwiftUI

struct EditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var task: RoomTask
    @State private var name: String
    @State private var selectedPriority: RoomTask.TaskPriority
    
    init(task: Binding<RoomTask>) {
        self._task = task
        self._name = State(initialValue: task.wrappedValue.name)
        self._selectedPriority = State(initialValue: task.wrappedValue.priority)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Task Name", text: $name)
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
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        task.name = name
        task.priority = selectedPriority
        dismiss()
    }
} 