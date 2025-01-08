import SwiftUI

struct AddMemberView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var collective: Collective
    @State private var email = ""
    @State private var invitationSent = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disabled(invitationSent)
                }
                
                if invitationSent {
                    Section {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.orange)
                            Text("Invitation Pending")
                                .foregroundColor(.orange)
                        }
                        Text("Waiting for \(email) to accept")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Section {
                        Button("Send Invitation") {
                            sendInvitation()
                        }
                        .disabled(email.isEmpty)
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
            }
        }
    }
    
    private func sendInvitation() {
        let invitation = Invitation(
            collectiveId: collective.id,
            email: email,
            invitedBy: "currentUser",
            status: .pending,
            dateCreated: Date()
        )
        collective.pendingInvitations.append(invitation)
        invitationSent = true
        
        // TODO: Send actual invitation email/notification
    }
}

struct AddMemberView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemberView(collective: .constant(Collective(name: "Test", createdBy: "user")))
    }
}