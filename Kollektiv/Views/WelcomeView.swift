import SwiftUI

struct WelcomeView: View {
    @Binding var showCreateCollective: Bool
    @Binding var collectives: [Collective]
    @Binding var selectedCollective: Collective?
    @State private var showJoinCollective = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to Kollektiv!")
                .font(.title)
            
            Text("Create or join a collective to get started")
                .foregroundColor(.secondary)
            
            Button(action: {
                showCreateCollective = true
            }) {
                Label("Get Started", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showJoinCollective) {
            JoinCollectiveView(
                collectives: $collectives,
                selectedCollective: $selectedCollective
            )
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(showCreateCollective: .constant(false), collectives: .constant([]), selectedCollective: .constant(nil))
    }
} 