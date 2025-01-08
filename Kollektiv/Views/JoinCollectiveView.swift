import SwiftUI

struct JoinCollectiveView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var collectives: [Collective]
    @Binding var selectedCollective: Collective?
    @State private var inviteCode = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isJoining = false
    
    private let codeLength = 6
    
    var body: some View {
        NavigationView {
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
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Don't have an invite code?")
                            .font(.headline)
                        Text("Ask a member of the collective to invite you. They can generate an invite code from their settings.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Join Collective")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
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
                selectedCollective = updatedCollective
                dismiss()
            }
        } else {
            errorMessage = "Invalid invitation code. Please check and try again."
            showError = true
        }
        
        isJoining = false
    }
}

struct JoinCollectiveView_Previews: PreviewProvider {
    static var previews: some View {
        JoinCollectiveView(collectives: .constant([]), selectedCollective: .constant(nil))
    }
} 