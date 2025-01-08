import SwiftUI

struct CollectiveSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var collective: Collective
    @Binding var collectives: [Collective]
    @Binding var selectedCollective: Collective?
    @State private var name: String
    @State private var description: String
    @State private var showConfirmDelete = false
    
    init(collective: Binding<Collective>, collectives: Binding<[Collective]>, selectedCollective: Binding<Collective?>) {
        self._collective = collective
        self._collectives = collectives
        self._selectedCollective = selectedCollective
        self._name = State(initialValue: collective.wrappedValue.name)
        self._description = State(initialValue: collective.wrappedValue.description ?? "")
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("General") {
                    TextField("Collective Name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Invite Code") {
                    HStack {
                        Text(collective.inviteCode)
                            .font(.system(.title2, design: .monospaced))
                        
                        Spacer()
                        
                        Button(action: {
                            UIPasteboard.general.string = collective.inviteCode
                        }) {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Button("Generate New Code") {
                        withAnimation {
                            collective.generateNewInviteCode()
                        }
                    }
                    .foregroundColor(.orange)
                }
                
                Section("Members") {
                    ForEach(collective.members) { member in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(member.username)
                                Text(member.email)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if member.role == .admin {
                                Text(member.role.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                
                if collective.createdBy == "currentUser" {
                    Section {
                        Button("Delete Collective") {
                            showConfirmDelete = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .alert("Delete Collective", isPresented: $showConfirmDelete) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteCollective()
                }
            } message: {
                Text("Are you sure you want to delete this collective? This action cannot be undone.")
            }
        }
    }
    
    private func saveChanges() {
        collective.name = name
        collective.description = description
        dismiss()
    }
    
    private func deleteCollective() {
        if let index = collectives.firstIndex(where: { $0.id == collective.id }) {
            collectives.remove(at: index)
            selectedCollective = nil
        }
        dismiss()
    }
} 