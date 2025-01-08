import SwiftUI

struct AddRoomView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var rooms: [Room]
    @State private var name = ""
    @State private var description = ""
    @State private var selectedType: RoomType = .custom
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Room Name", text: $name)
                    TextField("Description (optional)", text: $description)
                    Picker("Type", selection: $selectedType) {
                        ForEach(RoomType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
            }
            .navigationTitle("Add Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addRoom()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func addRoom() {
        let room = Room(
            name: name,
            description: description,
            type: selectedType
        )
        rooms.append(room)
        dismiss()
    }
} 