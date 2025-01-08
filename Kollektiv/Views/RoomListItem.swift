import SwiftUI

struct RoomListItem: View {
    let room: Room
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: room.type.iconName)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(room.name)
                    .font(.headline)
                
                if !room.description.isEmpty {
                    Text(room.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let lastCleaned = room.lastCleaned {
                    Text("Last cleaned: \(lastCleaned, style: .date)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
} 