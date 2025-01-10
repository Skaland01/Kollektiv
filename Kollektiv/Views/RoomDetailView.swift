import SwiftUI

struct RoomDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var room: Room
    @State private var isEditing = false
    @State private var showAddTask = false
    @State private var showTaskLimit = false
    @State private var showEditTaskSheet = false
    @State private var editingName: String
    @State private var editingDescription: String
    @State private var editingType: RoomType
    @State private var editingPeriod: CleaningPeriod
    @State private var newTaskName = ""
    @State private var selectedTask: RoomTask?
    
    private let taskLimit = 10
    
    init(room: Binding<Room>) {
        self._room = room
        self._editingName = State(initialValue: room.wrappedValue.name)
        self._editingDescription = State(initialValue: room.wrappedValue.description)
        self._editingType = State(initialValue: room.wrappedValue.type)
        self._editingPeriod = State(initialValue: room.wrappedValue.cleaningPeriod)
    }
    
    var body: some View {
        List {
            Section("Tasks (\(room.tasks.count)/\(taskLimit))") {
                ForEach($room.tasks) { $task in
                    TaskRow(task: task) {
                        withAnimation {
                            toggleTask(task)
                        }
                    } onTap: {
                        if isEditing {
                            selectedTask = task
                            showEditTaskSheet = true
                        }
                    }
                }
                .onDelete(perform: deleteTask)
                .onMove(perform: moveTask)
                
                if room.tasks.count < taskLimit {
                    Button(action: {
                        showAddTask = true
                    }) {
                        Label("Add Task", systemImage: "plus")
                    }
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
                    .onChange(of: editingType) { newValue in
                        withAnimation {
                            room.type = newValue
                        }
                    }
                    
                    Picker("Cleaning Period", selection: $editingPeriod) {
                        ForEach(CleaningPeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .onChange(of: editingPeriod) { newValue in
                        withAnimation {
                            room.cleaningPeriod = newValue
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
        .navigationTitle(editingName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(alignment: .leading, spacing: 0) {
                    if !editingDescription.isEmpty {
                        Text(editingDescription)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation {
                        if isEditing {
                            saveChanges()
                        } else {
                            editingName = room.name
                            editingDescription = room.description
                            editingType = room.type
                            editingPeriod = room.cleaningPeriod
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
        .onChange(of: isEditing) { newValue in
            if !newValue {
                saveChanges()
            }
        }
        .sheet(isPresented: $showAddTask) {
            NavigationView {
                Form {
                    Section {
                        TextField("Task Name", text: $newTaskName)
                    }
                    
                    Section {
                        Text("Tasks remaining: \(taskLimit - room.tasks.count)")
                            .foregroundColor(.secondary)
                    }
                }
                .navigationTitle("Add Task")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showAddTask = false
                            newTaskName = ""
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            addTask()
                        }
                        .disabled(newTaskName.isEmpty || room.tasks.count >= taskLimit)
                    }
                }
            }
        }
        .sheet(isPresented: $showEditTaskSheet, onDismiss: {
            selectedTask = nil
        }) {
            if let task = selectedTask {
                EditTaskSheet(task: Binding(
                    get: { task },
                    set: { updatedTask in
                        if let index = room.tasks.firstIndex(where: { $0.id == task.id }) {
                            room.tasks[index] = updatedTask
                        }
                    }
                ))
            }
        }
        .alert("Task Limit Reached", isPresented: $showTaskLimit) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can only add up to \(taskLimit) tasks for this room.")
        }
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
    }
    
    private func saveChanges() {
        withAnimation {
            room.name = editingName
            room.description = editingDescription
            room.type = editingType
            room.cleaningPeriod = editingPeriod
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
    
    private func moveTask(from source: IndexSet, to destination: Int) {
        var updatedTasks = room.tasks
        updatedTasks.move(fromOffsets: source, toOffset: destination)
        room.tasks = updatedTasks
    }
    
    private func deleteTask(at offsets: IndexSet) {
        room.tasks.remove(atOffsets: offsets)
    }
    
    private func addTask() {
        guard room.tasks.count < taskLimit else {
            showTaskLimit = true
            return
        }
        
        let task = RoomTask(
            name: newTaskName,
            priority: .medium,
            isCompleted: false
        )
        
        withAnimation {
            room.tasks.append(task)
        }
        
        newTaskName = ""
        showAddTask = false
    }
} 