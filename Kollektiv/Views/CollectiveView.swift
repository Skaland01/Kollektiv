import SwiftUI

struct CollectiveView: View {
    @State private var collectives: [Collective] = [] // Array of all user's collectives
    @State private var selectedCollective: Collective?
    @State private var showCreateCollective = false
    @State private var showAddMember = false
    @State private var showAddRoom = false
    @State private var pendingInvitations: [Invitation] = []
    @State private var showSettings = false
    
    private let invitationDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Group {
                if let collective = selectedCollective {
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
                        
                        Section(header: Text("Invite Code")) {
                            HStack {
                                Text(collective.inviteCode)
                                    .font(.system(.title2, design: .monospaced))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Button(action: {
                                    UIPasteboard.general.string = collective.inviteCode
                                }) {
                                    Image(systemName: "doc.on.doc")
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .padding(.vertical, 4)
                            
                            Text("Share this code with others to let them join your collective")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Section(header: Text("Pending Invitations")) {
                            if collective.pendingInvitations.isEmpty {
                                Text("No pending invitations")
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(collective.pendingInvitations) { invitation in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(invitation.email)
                                            Text("Invited: \(invitationDateFormatter.string(from: invitation.dateCreated))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Text(invitation.status.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                            .padding(4)
                                            .background(Color.orange.opacity(0.1))
                                            .cornerRadius(4)
                                    }
                                }
                                .onDelete(perform: cancelInvitation)
                            }
                        }
                        
                        Section(header: Text("Rooms")) {
                            ForEach(Array(collective.rooms.enumerated()), id: \.element.id) { index, room in
                                let roomBinding = Binding(
                                    get: { room },
                                    set: { newRoom in
                                        if let collectiveIndex = collectives.firstIndex(where: { $0.id == selectedCollective?.id }) {
                                            var updatedCollective = collectives[collectiveIndex]
                                            updatedCollective.rooms[index] = newRoom
                                            collectives[collectiveIndex] = updatedCollective
                                            selectedCollective = updatedCollective
                                        }
                                    }
                                )
                                
                                NavigationLink {
                                    RoomDetailView(room: roomBinding)
                                } label: {
                                    RoomListItem(room: room) { }
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
                } else {
                    WelcomeView(
                        showCreateCollective: $showCreateCollective,
                        collectives: $collectives,
                        selectedCollective: $selectedCollective
                    )
                }
            }
            .navigationTitle(selectedCollective?.name ?? "Collective")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !collectives.isEmpty {
                        Menu {
                            ForEach(collectives) { collective in
                                Button(action: {
                                    selectedCollective = collective
                                }) {
                                    HStack {
                                        Text(collective.name)
                                        if collective.id == selectedCollective?.id {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            
                            Button(action: {
                                showCreateCollective = true
                            }) {
                                Label("Add New Collective", systemImage: "plus")
                            }
                        } label: {
                            HStack {
                                Text(selectedCollective?.name ?? "Select")
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                if selectedCollective != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button(action: {
                                showAddMember = true
                            }) {
                                Image(systemName: "person.badge.plus")
                            }
                            
                            Button(action: {
                                showSettings = true
                            }) {
                                Image(systemName: "gear")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showCreateCollective) {
                CreateOrJoinCollectiveView(
                    collective: $selectedCollective,
                    collectives: $collectives
                )
            }
            .sheet(isPresented: $showAddMember) {
                if let index = collectives.firstIndex(where: { $0.id == selectedCollective?.id }) {
                    AddMemberView(collective: Binding(
                        get: { self.collectives[index] },
                        set: { newValue in
                            self.collectives[index] = newValue
                            self.selectedCollective = newValue
                        }
                    ))
                }
            }
            .sheet(isPresented: $showAddRoom) {
                if let index = collectives.firstIndex(where: { $0.id == selectedCollective?.id }) {
                    AddRoomView(rooms: Binding(
                        get: { self.collectives[index].rooms },
                        set: { newRooms in
                            var updatedCollective = self.collectives[index]
                            updatedCollective.rooms = newRooms
                            self.collectives[index] = updatedCollective
                            self.selectedCollective = updatedCollective
                        }
                    ))
                }
            }
            .sheet(isPresented: $showSettings) {
                if let index = collectives.firstIndex(where: { $0.id == selectedCollective?.id }) {
                    CollectiveSettingsView(
                        collective: Binding(
                            get: { self.collectives[index] },
                            set: { newValue in
                                self.collectives[index] = newValue
                                self.selectedCollective = newValue
                            }
                        ),
                        collectives: $collectives,
                        selectedCollective: $selectedCollective
                    )
                }
            }
        }
    }
    
    private func deleteRoom(at offsets: IndexSet) {
        if var collective = selectedCollective {
            collective.rooms.remove(atOffsets: offsets)
            selectedCollective = collective
            // TODO: Update in collectives array and persist
        }
    }
    
    private func cancelInvitation(at offsets: IndexSet) {
        if let index = collectives.firstIndex(where: { $0.id == selectedCollective?.id }) {
            var updatedCollective = collectives[index]
            updatedCollective.pendingInvitations.remove(atOffsets: offsets)
            collectives[index] = updatedCollective
            selectedCollective = updatedCollective
        }
    }
}