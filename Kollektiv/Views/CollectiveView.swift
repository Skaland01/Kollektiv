import SwiftUI

struct CollectiveView: View {
    @State private var rooms: [Room] = []
    @State private var showAddRoom = false
    @State private var showEditRoom: Room?
    @State private var newRoomName = ""
    @State private var newRoomDescription = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Rooms")) {
                    ForEach(rooms) { room in
                        RoomListItem(room: room) {
                            showEditRoom = room
                        }
                    }
                    .onDelete(perform: deleteRoom)
                    
                    Button(action: {
                        showAddRoom = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Room")
                        }
                    }
                }
                
                Section(header: Text("Members")) {
                    Text("No members yet")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Collective")
            .sheet(isPresented: $showAddRoom) {
                AddRoomView(rooms: $rooms)
            }
            .sheet(item: $showEditRoom) { room in
                EditRoomView(room: room, rooms: $rooms)
            }
            .toolbar {
                Button(action: {
                    // Add member action
                }) {
                    Image(systemName: "person.badge.plus")
                }
            }
        }
    }
    
    private func deleteRoom(at offsets: IndexSet) {
        rooms.remove(atOffsets: offsets)
        // TODO: Update database
    }
}

struct RoomListItem: View {
    let room: Room
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(room.name)
                    .font(.headline)
                
                if !room.description.isEmpty {
                    Text(room.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let lastCleaned = room.lastCleaned {
                    Text("Last cleaned: \(lastCleaned, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .foregroundColor(.primary)
    }
}

struct AddRoomView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var rooms: [Room]
    @State private var name = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Room name", text: $name)
                    TextField("Description (optional)", text: $description)
                }
            }
            .navigationTitle("Add Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addRoom()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func addRoom() {
        let room = Room(name: name, description: description)
        rooms.append(room)
        // TODO: Save to database
        dismiss()
    }
}

struct EditRoomView: View {
    @Environment(\.dismiss) private var dismiss
    let room: Room
    @Binding var rooms: [Room]
    @State private var name: String
    @State private var description: String
    
    init(room: Room, rooms: Binding<[Room]>) {
        self.room = room
        self._rooms = rooms
        self._name = State(initialValue: room.name)
        self._description = State(initialValue: room.description)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Room name", text: $name)
                    TextField("Description (optional)", text: $description)
                }
            }
            .navigationTitle("Edit Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        updateRoom()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func updateRoom() {
        if let index = rooms.firstIndex(where: { $0.id == room.id }) {
            var updatedRoom = room
            updatedRoom.name = name
            updatedRoom.description = description
            rooms[index] = updatedRoom
            // TODO: Update database
        }
        dismiss()
    }
}