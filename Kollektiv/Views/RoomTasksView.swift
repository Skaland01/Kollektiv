import SwiftUI

struct RoomTasksView: View {
    @Binding var room: Room
    @State private var editMode = EditMode.inactive
    @State private var showAddTask = false
    @State private var newTaskName = ""
    
    var body: some View {
        List {
            ForEach(room.tasks.indices, id: \.self) { index in
                TaskRowView(task: binding(for: index))
            }
            .onMove { from, to in
                room.tasks.move(fromOffsets: from, toOffset: to)
            }
            .onDelete { indexSet in
                room.tasks.remove(atOffsets: indexSet)
            }
            
            Button {
                showAddTask = true
            } label: {
                Label("Add Task", systemImage: "plus.circle.fill")
            }
        }
        .listStyle(.insetGrouped)
        .environment(\.editMode, $editMode)
        .toolbar {
            EditButton()
        }
        .alert("Add Task", isPresented: $showAddTask) {
            TextField("Task name", text: $newTaskName)
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                addTask()
            }
        } message: {
            Text("Enter the name of the new task")
        }
    }
    
    private func binding(for index: Int) -> Binding<RoomTask> {
        Binding(
            get: { room.tasks[index] },
            set: { room.tasks[index] = $0 }
        )
    }
    
    private func addTask() {
        guard !newTaskName.isEmpty else { return }
        let task = RoomTask(name: newTaskName)
        room.tasks.append(task)
        newTaskName = ""
    }
}

struct TaskRowView: View {
    @Binding var task: RoomTask
    
    var body: some View {
        HStack {
            Button {
                task.isCompleted.toggle()
                if task.isCompleted {
                    task.lastCompletedDate = Date()
                } else {
                    task.lastCompletedDate = nil
                }
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .strikethrough(task.isCompleted)
                
                HStack {
                    Image(systemName: task.priority.icon)
                        .foregroundColor(task.priority.color)
                    Text(task.priority.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let completedDate = task.lastCompletedDate {
                        Spacer()
                        Text(completedDate, style: .date)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
} 