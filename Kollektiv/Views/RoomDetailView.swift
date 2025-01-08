import SwiftUI

struct RoomDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var room: Room
    @State private var isEditing = false
    @State private var showAddTask = false
    @State private var showCleaningConfirmation = false
    @State private var editingName: String
    @State private var editingDescription: String
    @State private var editingType: RoomType
    @State private var editingPeriod: CleaningPeriod
    
    private let currentUserId = "currentUser" // Replace with actual user ID
    
    init(room: Binding<Room>) {
        self._room = room
        self._editingName = State(initialValue: room.wrappedValue.name)
        self._editingDescription = State(initialValue: room.wrappedValue.description)
        self._editingType = State(initialValue: room.wrappedValue.type)
        self._editingPeriod = State(initialValue: room.wrappedValue.cleaningPeriod)
    }
    
    var body: some View {
        List {
            if !room.tasks.isEmpty {
                Section {
                    HStack {
                        ProgressView(value: Double(completedTasksCount), total: Double(room.tasks.count))
                        Text("\(completedTasksCount)/\(room.tasks.count) completed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            
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
            
            if !room.tasks.isEmpty {
                Section {
                    Button {
                        showCleaningConfirmation = true
                    } label: {
                        HStack {
                            Text("Mark Room as Cleaned")
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                    .disabled(!room.isCurrentlyCleaned)
                }
                
                if let lastCleaned = room.lastCleaned, let cleanedBy = room.lastCleanedBy {
                    Section {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Last cleaned:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack {
                                Text(lastCleaned, style: .date)
                                Text("by @\(cleanedBy)")
                            }
                            .font(.subheadline)
                        }
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
            AddTaskView(tasks: $room.tasks)
        }
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
        .alert("Mark Room as Cleaned", isPresented: $showCleaningConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                markRoomAsCleaned()
            }
        } message: {
            Text("This will mark all tasks as completed and reset them for the next cleaning cycle.")
        }
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
    
    private func deleteTask(at offsets: IndexSet) {
        room.tasks.remove(atOffsets: offsets)
    }
    
    private var completedTasksCount: Int {
        room.tasks.filter { $0.isCompleted }.count
    }
    
    private func markRoomAsCleaned() {
        withAnimation {
            room.markAsCleaned(by: currentUserId)
            
            // Add notification for other members
            let notification = CollectiveNotification(
                type: .roomCleaned,
                message: "\(currentUserId) cleaned the \(room.name.lowercased())",
                date: Date(),
                collectiveId: UUID() // Replace with actual collective ID
            )
            
            // Add notification to collective
            // collective.notifications.append(notification)
            
            // Reset tasks for next cleaning cycle
            room.resetTasks()
        }
    }
} 