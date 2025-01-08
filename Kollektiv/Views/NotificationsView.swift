import SwiftUI

struct NotificationsView: View {
    let notifications: [CollectiveNotification]
    
    var body: some View {
        List {
            ForEach(notifications.sorted(by: { $0.date > $1.date })) { notification in
                HStack {
                    Image(systemName: notification.type.icon)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(notification.message)
                        
                        Text(notification.date, style: .relative)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Activity")
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotificationsView(notifications: [
                CollectiveNotification(
                    type: .memberLeft,
                    message: "John left the collective",
                    date: Date(),
                    collectiveId: UUID()
                ),
                CollectiveNotification(
                    type: .memberJoined,
                    message: "Sarah joined the collective",
                    date: Date().addingTimeInterval(-3600),
                    collectiveId: UUID()
                )
            ])
        }
    }
} 