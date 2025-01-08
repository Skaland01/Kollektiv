import SwiftUI

struct ProfileView: View {
    @State private var username: String = "Your Name"
    @State private var email: String = "your.email@example.com"
    @State private var showEditProfile = false
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.accentColor)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(username)
                                .font(.headline)
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Settings Section
                Section("Settings") {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                    
                    NavigationLink {
                        // Add language selection view here
                    } label: {
                        HStack {
                            Label("Language", systemImage: "globe")
                            Spacer()
                            Text("English")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Account Section
                Section("Account") {
                    Button {
                        showEditProfile = true
                    } label: {
                        Label("Edit Profile", systemImage: "pencil")
                    }
                    
                    Button {
                        // Add help/support action
                    } label: {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                    
                    Button {
                        // Add privacy policy action
                    } label: {
                        Label("Privacy Policy", systemImage: "lock.shield")
                    }
                }
                
                // Logout Section
                Section {
                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(username: $username, email: $email)
            }
            .alert("Log Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    // Add logout action
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}

// Edit Profile View
struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var username: String
    @Binding var email: String
    @State private var editingUsername: String
    @State private var editingEmail: String
    
    init(username: Binding<String>, email: Binding<String>) {
        self._username = username
        self._email = email
        self._editingUsername = State(initialValue: username.wrappedValue)
        self._editingEmail = State(initialValue: email.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile Information") {
                    TextField("Username", text: $editingUsername)
                    TextField("Email", text: $editingEmail)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        username = editingUsername
                        email = editingEmail
                        dismiss()
                    }
                }
            }
        }
    }
} 