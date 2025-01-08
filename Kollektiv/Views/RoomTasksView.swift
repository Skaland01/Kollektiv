import SwiftUI

struct RoomTasksView: View {
    @Binding var room: Room
    @State private var newTaskName = ""
    @State private var showAddTask = false
    
    var body: some View {
        List {
            Section {
                ForEach(room.tasks) { task in
                    TaskChecklistItem(task: binding(for: task))
                }
                .onDelete(perform: deleteTasks)
                
                Button(action: {
                    showAddTask = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Task")
                    }
                }
            } header: {
                Text("Cleaning Tasks")
            } footer: {
                if !room.tasks.isEmpty {
                    Text("Swipe left to delete tasks")
                        .font(.caption)
                }
            }
        }
        .navigationTitle(room.name)
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
    
    private func binding(for task: RoomTask) -> Binding<RoomTask> {
        guard let taskIndex = room.tasks.firstIndex(where: { $0.id == task.id }) else {
            fatalError("Task not found")
        }
        return $room.tasks[taskIndex]
    }
    
    private func addTask() {
        guard !newTaskName.isEmpty else { return }
        let task = RoomTask(name: newTaskName)
        room.tasks.append(task)
        newTaskName = ""
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        room.tasks.remove(atOffsets: offsets)
    }
}

struct TaskChecklistItem: View {
    @Binding var task: RoomTask
    
    var body: some View {
        HStack {
            Button(action: {
                task.isCompleted.toggle()
                if task.isCompleted {
                    task.lastCompletedDate = Date()
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading) {
                Text(task.name)
                    .strikethrough(task.isCompleted)
                
                if let completedDate = task.lastCompletedDate {
                    Text("Completed: \(completedDate, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
} 