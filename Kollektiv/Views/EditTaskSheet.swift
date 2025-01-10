import SwiftUI

struct EditTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var task: RoomTask
    @State private var editingName: String
    @State private var editingPriority: RoomTask.TaskPriority
    
    init(task: Binding<RoomTask>) {
        self._task = task
        self._editingName = State(initialValue: task.wrappedValue.name)
        self._editingPriority = State(initialValue: task.wrappedValue.priority)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Task Name", text: $editingName)
                    
                    Picker("Priority", selection: $editingPriority) {
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
                    .disabled(editingName.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        task.name = editingName
        task.priority = editingPriority
        dismiss()
    }
}

struct EditTaskSheet_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskSheet(task: .constant(RoomTask(name: "Sample Task")))
    }
} 