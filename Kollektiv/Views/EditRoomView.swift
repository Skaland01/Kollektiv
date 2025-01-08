import SwiftUI

struct EditRoomView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var room: Room
    @State private var name: String
    @State private var description: String
    @State private var selectedType: RoomType
    @State private var selectedPeriod: CleaningPeriod
    
    init(room: Binding<Room>) {
        self._room = room
        self._name = State(initialValue: room.wrappedValue.name)
        self._description = State(initialValue: room.wrappedValue.description)
        self._selectedType = State(initialValue: room.wrappedValue.type)
        self._selectedPeriod = State(initialValue: room.wrappedValue.cleaningPeriod)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Room Name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section {
                    Picker("Room Type", selection: $selectedType) {
                        ForEach(RoomType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.iconName)
                                .tag(type)
                        }
                    }
                }
                
                Section {
                    Picker("Cleaning Period", selection: $selectedPeriod) {
                        ForEach(CleaningPeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                } footer: {
                    Text("This room should be cleaned \(selectedPeriod.rawValue.lowercased())")
                }
            }
            .navigationTitle("Edit Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        room.name = name
        room.description = description
        room.type = selectedType
        room.cleaningPeriod = selectedPeriod
        dismiss()
    }
} 