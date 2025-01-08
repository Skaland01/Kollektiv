import SwiftUI

struct CollectiveView: View {
    @State private var collective: Collective?
    @State private var showCreateCollective = false
    @State private var showAddMember = false
    @State private var showAddRoom = false
    
    var body: some View {
        NavigationView {
            Group {
                if let collective = collective {
                    CollectiveDetailView(collective: collective)
                } else {
                    VStack(spacing: 20) {
                        Text("Welcome to Kollektiv!")
                            .font(.title)
                        
                        Text("Create or join a collective to get started")
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            showCreateCollective = true
                        }) {
                            Label("Create Collective", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Collective")
            .sheet(isPresented: $showCreateCollective) {
                CreateCollectiveView(collective: $collective)
            }
        }
    }
}

struct CollectiveDetailView: View {
    @State var collective: Collective
    @State private var showAddMember = false
    @State private var showAddRoom = false
    
    var body: some View {
        List {
            Section(header: Text("Members")) {
                ForEach(collective.members) { member in
                    HStack {
                        Text(member.username)
                        Spacer()
                        if member.id.uuidString == collective.createdBy {
                            Text("Admin")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Button(action: {
                    showAddMember = true
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("Add Member")
                    }
                }
            }
            
            Section(header: Text("Rooms")) {
                ForEach(collective.rooms) { room in
                    RoomListItem(room: room) {
                        // Navigate to room detail
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
        }
        .sheet(isPresented: $showAddMember) {
            AddMemberView(collective: $collective)
        }
        .sheet(isPresented: $showAddRoom) {
            AddRoomView(rooms: $collective.rooms)
        }
    }
    
    private func deleteRoom(at offsets: IndexSet) {
        collective.rooms.remove(atOffsets: offsets)
    }
}

struct CreateCollectiveView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var collective: Collective?
    @State private var name = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Collective Name", text: $name)
                    TextField("Description (optional)", text: $description)
                }
                
                Section {
                    Text("You'll be able to add members after creating the collective.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Create Collective")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createCollective()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func createCollective() {
        let newCollective = Collective(
            name: name,
            description: description,
            createdBy: "currentUser" // Replace with actual user ID
        )
        collective = newCollective
        dismiss()
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