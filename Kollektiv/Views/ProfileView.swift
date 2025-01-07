import SwiftUI

struct ProfileView: View {
    @State private var username: String = "Your Name"
    @State private var email: String = "your.email@example.com"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Username", text: $username)
                    TextField("Email", text: $email)
                }
                
                Section(header: Text("Preferences")) {
                    // Add preferences here
                }
                
                Section {
                    Button("Sign Out") {
                        // Sign out action
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
        }
    }
} 