import SwiftUI

struct CreateCollectiveView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var collective: Collective?
    @Binding var collectives: [Collective]
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
        var newCollective = Collective(
            name: name,
            description: description,
            createdBy: "currentUser"
        )
        
        let currentUser = User(
            username: "Your Name",
            email: "your.email@example.com",
            role: .admin
        )
        newCollective.members.append(currentUser)
        
        collectives.append(newCollective)
        collective = newCollective
        dismiss()
    }
}

struct CreateCollectiveView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCollectiveView(
            collective: .constant(nil),
            collectives: .constant([])
        )
    }
} 