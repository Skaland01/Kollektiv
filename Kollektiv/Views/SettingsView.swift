import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("language") private var selectedLanguage = Language.english.rawValue
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Appearance") {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                }
                
                Section("Language") {
                    ForEach(Language.allCases) { language in
                        Button {
                            selectedLanguage = language.rawValue
                            UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
                            // Optionally restart the app to apply changes
                        } label: {
                            HStack {
                                Text(language.icon)
                                Text(language.displayName)
                                Spacer()
                                if selectedLanguage == language.rawValue {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
                
                Section("Notifications") {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Enable Notifications", systemImage: "bell.fill")
                    }
                }
                
                Section("App") {
                    NavigationLink {
                        Text("About Kollektiv")
                            .navigationTitle("About")
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }
                    
                    Link(destination: URL(string: "https://example.com/terms")!) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                    
                    Link(destination: URL(string: "https://example.com/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Label("Reset All Settings", systemImage: "arrow.counterclockwise")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Reset Settings", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetSettings()
                }
            } message: {
                Text("Are you sure you want to reset all settings to default?")
            }
        }
        .environment(\.locale, .init(identifier: selectedLanguage))
    }
    
    private func resetSettings() {
        isDarkMode = false
        notificationsEnabled = true
        selectedLanguage = Language.english.rawValue
        UserDefaults.standard.set([Language.english.rawValue], forKey: "AppleLanguages")
    }
} 