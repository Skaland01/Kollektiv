import SwiftUI

struct AddMemberView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var collective: Collective
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button("Send Invitation") {
                        // TODO: Implement invitation
                        dismiss()
                    }
                    .disabled(email.isEmpty)
                }
            }
            .navigationTitle("Invite Member")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddMemberView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemberView(collective: .constant(Collective(name: "Test", createdBy: "user")))
    }
}