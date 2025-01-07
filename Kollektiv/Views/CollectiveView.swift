import SwiftUI

struct CollectiveView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Your Collective")) {
                    // List of roommates will go here
                }
                
                Section(header: Text("Invites")) {
                    // Pending invites will go here
                }
            }
            .navigationTitle("Collective")
            .toolbar {
                Button(action: {
                    // Add new roommate action
                }) {
                    Image(systemName: "person.badge.plus")
                }
            }
        }
    }
}