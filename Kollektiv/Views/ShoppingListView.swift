import SwiftUI

struct ShoppingListView: View {
    @State private var shoppingItems: [ShoppingItem] = []
    @State private var newItemName: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        TextField("Add new item", text: $newItemName)
                        Button(action: {
                            // Add item action
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
                
                Section {
                    // Shopping items will go here
                }
            }
            .navigationTitle("Shopping List")
        }
    }
} 