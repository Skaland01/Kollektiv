import SwiftUI

struct ProfileView: View {
    @State private var username: String = "Your Name"
    @State private var email: String = "your.email@example.com"
    @State private var showEditProfile = false
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var showLogoutAlert = false
    @State private var showSettings = false
    @AppStorage("selectedAvatar") private var selectedAvatar = Avatar.defaultAvatar.rawValue
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    HStack(spacing: 16) {
                        Menu {
                            ForEach(Avatar.allCases) { avatar in
                                Button {
                                    selectedAvatar = avatar.rawValue
                                } label: {
                                    HStack {
                                        avatar.image
                                            .foregroundColor(.accentColor)
                                        Text(avatar.displayName)
                                        if selectedAvatar == avatar.rawValue {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Avatar(rawValue: selectedAvatar)?.image
                                .font(.system(size: 60))
                                .foregroundColor(.accentColor)
                                .overlay(
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.accentColor)
                                        .background(Color(.systemBackground))
                                        .clipShape(Circle())
                                        .offset(x: 20, y: 20)
                                )
                        }
                        
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
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
            .sheet(isPresented: $showSettings) {
                SettingsView()
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
    @AppStorage("selectedAvatar") private var selectedAvatar = Avatar.defaultAvatar.rawValue
    @State private var showAvatarPicker = false
    
    init(username: Binding<String>, email: Binding<String>) {
        self._username = username
        self._email = email
        self._editingUsername = State(initialValue: username.wrappedValue)
        self._editingEmail = State(initialValue: email.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile Picture") {
                    Button {
                        showAvatarPicker = true
                    } label: {
                        HStack {
                            Avatar(rawValue: selectedAvatar)?.image
                                .font(.title)
                                .foregroundColor(.accentColor)
                            Text("Change Avatar")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
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
            .sheet(isPresented: $showAvatarPicker) {
                AvatarPickerView(selectedAvatar: $selectedAvatar)
            }
        }
    }
}

// New AvatarPickerView
struct AvatarPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedAvatar: String
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Avatar.allCases) { avatar in
                        Button {
                            selectedAvatar = avatar.rawValue
                            dismiss()
                        } label: {
                            VStack {
                                avatar.image
                                    .font(.system(size: 50))
                                    .foregroundColor(selectedAvatar == avatar.rawValue ? .accentColor : .gray)
                                
                                Text(avatar.displayName)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedAvatar == avatar.rawValue ? Color.accentColor : Color.clear, lineWidth: 2)
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 