//
//  ContentView.swift
//  Kollektiv
//
//  Created by Even Skåland on 07/01/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("language") private var selectedLanguage = Language.english.rawValue
    @StateObject private var collectiveStore = CollectiveStore()
    
    var body: some View {
        TabView {
            if let collective = collectiveStore.currentCollective {
                TasksView(collective: .constant(collective))
                    .tabItem {
                        Label("Tasks", systemImage: "checklist")
                    }
                
                ShoppingListView()
                    .tabItem {
                        Label("Shopping", systemImage: "cart")
                    }
                
                CollectiveView()
                    .tabItem {
                        Label("Collective", systemImage: "person.3")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            } else {
                Text("Select a collective")
                    .tabItem {
                        Label("Tasks", systemImage: "checklist")
                    }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environment(\.locale, Language(rawValue: selectedLanguage)?.locale ?? .current)
    }
}

class CollectiveStore: ObservableObject {
    @Published var currentCollective: Collective?
    
    init() {
        // Initialize with sample data
        var collective = Collective(name: "My Home", createdBy: "currentUser")
        
        // Add current user
        let currentUser = User(username: "currentUser", email: "user@example.com")
        collective.members = [currentUser]
        
        // Add sample rooms
        collective.rooms = [
            Room(name: "Kitchen", type: .kitchen),
            Room(name: "Living Room", type: .livingRoom),
            Room(name: "Bathroom", type: .bathroom)
        ]
        
        // Distribute rooms
        collective.distributeRooms()
        
        currentCollective = collective
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


