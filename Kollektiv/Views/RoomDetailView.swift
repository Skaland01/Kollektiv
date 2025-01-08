import SwiftUI

struct RoomDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var room: Room
    @State private var isEditing = false
    @State private var showAddTask = false
    @State private var editingName: String
    @State private var editingDescription: String
    @State private var editingType: RoomType
    @State private var editingPeriod: CleaningPeriod
    
    init(room: Binding<Room>) {
        self._room = room
        self._editingName = State(initialValue: room.wrappedValue.name)
        self._editingDescription = State(initialValue: room.wrappedValue.description)
        self._editingType = State(initialValue: room.wrappedValue.type)
        self._editingPeriod = State(initialValue: room.wrappedValue.cleaningPeriod)
    }
    
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
                            if isEditing {
                                // Show inline task editing
                            }
                        }
                    )
                }
                .onMove { from, to in
                    var updatedTasks = room.tasks
                    updatedTasks.move(fromOffsets: from, toOffset: to)
                    room.tasks = updatedTasks
                }
                .onDelete(perform: deleteTask)
                
                Button(action: {
                    showAddTask = true
                }) {
                    Label("Add Task", systemImage: "plus")
                }
            }
            
            Section("Settings") {
                if isEditing {
                    TextField("Room Name", text: $editingName)
                    TextField("Description", text: $editingDescription)
                    
                    Picker("Room Type", selection: $editingType) {
                        ForEach(RoomType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.iconName)
                                .tag(type)
                        }
                    }
                    
                    Picker("Cleaning Period", selection: $editingPeriod) {
                        ForEach(CleaningPeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                } else {
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
        }
        .navigationTitle(room.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation {
                        if isEditing {
                            saveChanges()
                        }
                        isEditing.toggle()
                    }
                }
            }
            
            if isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskView(tasks: $room.tasks)
        }
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
    }
    
    private func saveChanges() {
        room.name = editingName
        room.description = editingDescription
        room.type = editingType
        room.cleaningPeriod = editingPeriod
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