import SwiftUI

struct AddMemberView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var collective: Collective
    @State private var inviteMethod: InviteMethod = .email
    @State private var email = ""
    @State private var username = ""
    @State private var invitationSent = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    enum InviteMethod {
        case email
        case username
    }
    
    private var isEmailValid: Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private var isUsernameValid: Bool {
        username.count >= 3 // Add more validation if needed
    }
    
    private var recipient: String {
        inviteMethod == .email ? email : username
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Invite by", selection: $inviteMethod) {
                        Text("Email").tag(InviteMethod.email)
                        Text("Username").tag(InviteMethod.username)
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 8)
                    
                    if inviteMethod == .email {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .disabled(invitationSent)
                    } else {
                        TextField("Username", text: $username)
                            .textInputAutocapitalization(.never)
                            .disabled(invitationSent)
                    }
                } footer: {
                    if inviteMethod == .email && !email.isEmpty && !isEmailValid {
                        Text("Please enter a valid email address")
                            .foregroundColor(.red)
                    }
                }
                
                if invitationSent {
                    Section {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.orange)
                            Text("Invitation Sent")
                                .foregroundColor(.orange)
                        }
                        Text("Invitation sent to \(recipient)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Section {
                        Button("Send Invitation") {
                            validateAndSendInvitation()
                        }
                        .disabled(inviteMethod == .email ? (email.isEmpty || !isEmailValid) : !isUsernameValid)
                    }
                }
                
                if let expiredInvitation = collective.pendingInvitations.first(where: { 
                    $0.email.lowercased() == recipient.lowercased() && $0.isExpired 
                }) {
                    Section {
                        Button("Resend Expired Invitation") {
                            resendInvitation(expiredInvitation)
                        }
                        .foregroundColor(.orange)
                    }
                }
            }
            .navigationTitle("Invite Member")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                if invitationSent {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Invite Another") {
                            invitationSent = false
                            email = ""
                        }
                    }
                }
            }
            .alert("Invitation Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func validateAndSendInvitation() {
        if inviteMethod == .email {
            validateAndSendEmailInvitation()
        } else {
            validateAndSendUsernameInvitation()
        }
    }
    
    private func validateAndSendEmailInvitation() {
        // Existing email validation logic
        guard isEmailValid else {
            errorMessage = "Please enter a valid email address"
            showError = true
            return
        }
        
        // Rest of the existing validation...
        sendInvitation(for: email)
    }
    
    private func validateAndSendUsernameInvitation() {
        guard isUsernameValid else {
            errorMessage = "Please enter a valid username"
            showError = true
            return
        }
        
        // TODO: Check if username exists in the system
        // This would require a user lookup service
        
        sendInvitation(for: username)
    }
    
    private func sendInvitation(for recipient: String) {
        let invitation = Invitation(
            collectiveId: collective.id,
            email: recipient.lowercased(),
            invitedBy: "currentUser",
            status: .pending,
            dateCreated: Date()
        )
        
        var updatedCollective = collective
        updatedCollective.pendingInvitations.append(invitation)
        collective = updatedCollective
        
        invitationSent = true
    }
    
    private func resendInvitation(_ oldInvitation: Invitation) {
        // Remove old invitation
        var updatedCollective = collective
        updatedCollective.pendingInvitations.removeAll { $0.id == oldInvitation.id }
        
        // Create new invitation
        let newInvitation = Invitation(
            collectiveId: collective.id,
            email: oldInvitation.email,
            invitedBy: "currentUser",
            status: .pending,
            dateCreated: Date()
        )
        
        updatedCollective.pendingInvitations.append(newInvitation)
        collective = updatedCollective
        invitationSent = true
    }
}

struct AddMemberView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemberView(collective: .constant(Collective(name: "Test", createdBy: "user")))
    }
}