import SwiftUI

struct RoomDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var room: Room
    @State private var showEditRoom = false
    @State private var showAddTask = false
    @State private var selectedTask: RoomTask?
    
    var body: some View {
        List {
            Section("Tasks") {
                ForEach(room.tasks) { task in
                    TaskRow(
                        task: task,
                        onToggle: {
                            withAnimation {
                                toggleTask(task)
                            }
                        },
                        onTap: {
                            selectedTask = task
                        }
                    )
                }
                .onDelete(perform: deleteTask)
                
                Button(action: {
                    showAddTask = true
                }) {
                    Label("Add Task", systemImage: "plus")
                }
            }
            
            Section("Settings") {
                HStack {
                    Label("Room Type", systemImage: room.type.iconName)
                    Spacer()
                    Text(room.type.rawValue)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Label("Cleaning Period", systemImage: "calendar")
                    Spacer()
                    Text(room.cleaningPeriod.rawValue)
                        .foregroundColor(.secondary)
                }
                
                if !room.description.isEmpty {
                    HStack {
                        Label("Description", systemImage: "text.alignleft")
                        Spacer()
                        Text(room.description)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let lastCleaned = room.lastCleaned {
                    HStack {
                        Label("Last Cleaned", systemImage: "clock")
                        Spacer()
                        Text(lastCleaned, style: .date)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle(room.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEditRoom = true
                }
            }
        }
        .sheet(isPresented: $showEditRoom) {
            EditRoomView(room: $room)
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskView(tasks: Binding(
                get: { room.tasks },
                set: { room.tasks = $0 }
            ))
        }
        .sheet(isPresented: Binding(
            get: { selectedTask != nil },
            set: { if !$0 { selectedTask = nil } }
        )) {
            if let index = room.tasks.firstIndex(where: { $0.id == selectedTask?.id }) {
                EditTaskView(task: Binding(
                    get: { room.tasks[index] },
                    set: { updatedTask in
                        var updatedTasks = room.tasks
                        updatedTasks[index] = updatedTask
                        room.tasks = updatedTasks
                        selectedTask = nil
                    }
                ))
            }
        }
    }
    
    private func toggleTask(_ task: RoomTask) {
        if let index = room.tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTasks = room.tasks
            updatedTasks[index].isCompleted.toggle()
            updatedTasks[index].lastCompletedDate = updatedTasks[index].isCompleted ? Date() : nil
            room.tasks = updatedTasks
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        room.tasks.remove(atOffsets: offsets)
    }
} 