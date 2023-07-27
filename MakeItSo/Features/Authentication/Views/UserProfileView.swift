import SwiftUI
import Combine
import Factory
import FirebaseAnalyticsSwift
import FirebaseAuth

struct UserProfileView: View {
    @StateObject var viewModel = UserProfileViewModel()
    @Environment(\.dismiss) var dismiss
    @State var presentingConfirmationDialog = false
    
    private func deleteAccount() {
        Task {
            if await viewModel.deleteAccount() == true {
                dismiss()
            }
        }
    }
    
    private func signOut() {
        viewModel.signOut()
    }
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .padding(4)
                        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
                        .frame(maxWidth: .infinity)
                    Button(action: {}) {
                        Text("edit")
                    }
                }
            }
            .listRowBackground(Color(UIColor.systemGroupedBackground))
            
            Section("Email") {
                ProfileRow(title: "Name", value: viewModel.displayName)
                ProfileRow(title: "Email", value: viewModel.email)
                ProfileRow(title: "UID", value: viewModel.user?.uid ?? "(unkonwn)")
                ProfileRow(title: "Provider", value: viewModel.provider)
                ProfileRow(title: "Anonymous/Guest user", value: viewModel.isGuestUser ? "Yes" : "No")
                ProfileRow(title: "Verified", value: viewModel.isVerified ? "Yes" : "No")
            }
            
            Section {
                Button(role: .cancel, action: signOut) {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity)

                }
            }
            
            Section {
                Button(role: .destructive, action: {
                    presentingConfirmationDialog.toggle()
                }) {
                    Text("Delete Account")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .analyticsScreen(name: "\(Self.self)")
        .confirmationDialog(
            "Deleting your account is permanent. Do you want to delete your account?",
            isPresented: $presentingConfirmationDialog,
            titleVisibility: .visible) {
                Button("Delete Account", role: .destructive, action: deleteAccount)
                Button("Cancel", role: .cancel, action: {})
            }
    }
}

struct ProfileRow: View {
    let title: String
    let value: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption)
            Text(value)
        }
    }
}

#Preview {
    NavigationStack {
        UserProfileView()
    }
}
