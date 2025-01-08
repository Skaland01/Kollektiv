import SwiftUI

struct TaskRow: View {
    let task: RoomTask
    let onToggle: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            Text(task.name)
                .strikethrough(task.isCompleted)
            
            Spacer()
            
            Image(systemName: task.priority.icon)
                .foregroundColor(task.priority.color)
            
            if let date = task.lastCompletedDate {
                Text(date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
} 