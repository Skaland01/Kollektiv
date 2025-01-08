import SwiftUI

struct CollectiveView: View {
    @State private var rooms: [Room] = []
    @State private var showAddRoom = false
    @State private var showEditRoom: Room?
    
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