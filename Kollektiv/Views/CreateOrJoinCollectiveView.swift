import SwiftUI

struct CreateOrJoinCollectiveView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var collective: Collective?
    @Binding var collectives: [Collective]
    @State private var selectedTab = 0
    
    // Create properties
    @State private var name = ""
    @State private var description = ""
    
    // Join properties
    @State private var inviteCode = ""
    @State private var isJoining = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let codeLength = 6
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab selector
                Picker("", selection: $selectedTab) {
                    Text("Create").tag(0)
                    Text("Join").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if selectedTab == 0 {
                    // Create Collective Form
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
                } else {
                    // Join Collective Form
                    Form {
                        Section {
                            TextField("Enter Invitation Code", text: $inviteCode)
                                .font(.system(.title2, design: .monospaced))
                                .multilineTextAlignment(.center)
                                .textInputAutocapitalization(.never)
                                .onChange(of: inviteCode) { newValue in
                                    inviteCode = newValue.uppercased()
                                    if newValue.count > codeLength {
                                        inviteCode = String(newValue.prefix(codeLength))
                                    }
                                }
                        } footer: {
                            Text("Enter the 6-digit code from your invitation")
                                .foregroundColor(.secondary)
                        }
                        
                        Section {
                            Button(action: joinCollective) {
                                if isJoining {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                } else {
                                    Text("Join Collective")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .disabled(inviteCode.count != codeLength || isJoining)
                        }
                    }
                }
            }
            .navigationTitle(selectedTab == 0 ? "Create Collective" : "Join Collective")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                if selectedTab == 0 {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Create") {
                            createCollective()
                        }
                        .disabled(name.isEmpty)
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func createCollective() {
        // Create new collective
        var newCollective = Collective(
            name: name,
            description: description,
            createdBy: "currentUser"
        )
        
        // Add current user as admin
        let currentUser = User(
            username: "Your Name",  // Replace with actual user name
            email: "your.email@example.com",  // Replace with actual email
            role: .admin
        )
        newCollective.members.append(currentUser)
        
        // Update collectives
        collectives.append(newCollective)
        collective = newCollective
        dismiss()
    }
    
    private func joinCollective() {
        guard inviteCode.count == codeLength else { return }
        
        isJoining = true
        
        // Find collective with matching invite code
        if let collective = collectives.first(where: { $0.inviteCode == inviteCode }) {
            // Add current user to collective
            var updatedCollective = collective
            let currentUser = User(username: "currentUser", email: "user@example.com") // Replace with actual user
            updatedCollective.members.append(currentUser)
            
            // Update collectives array
            if let index = collectives.firstIndex(where: { $0.id == collective.id }) {
                collectives[index] = updatedCollective
                self.collective = updatedCollective
                dismiss()
            }
        } else {
            errorMessage = "Invalid invitation code. Please check and try again."
            showError = true
        }
        
        isJoining = false
    }
}

struct CreateOrJoinCollectiveView_Previews: PreviewProvider {
    static var previews: some View {
        CreateOrJoinCollectiveView(
            collective: .constant(nil),
            collectives: .constant([])
        )
    }
} 