//
//  ContentView.swift
//  Kollektiv
//
//  Created by Even Skåland on 07/01/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TasksView()
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


