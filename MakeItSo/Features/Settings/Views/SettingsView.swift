import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = SettingsViewModel()
    @State var isShowSignUpDialogPresented = false
    
    private func signUp() {
        isShowSignUpDialogPresented.toggle()
    }
    
    private func signOut() {
        viewModel.signOut()
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink(destination: UserProfileView()) {
                        Label("Account", systemImage: "person.circle")
                    }
                }
                
                Section {
                    if viewModel.isGuestUser {
                        Button(action: signUp) {
                            Text("Sign up")
                                .frame(maxWidth: .infinity)
                        }
                    } else {
                        Button(action: signUp) {
                            Text("Sign up")
                                .frame(maxWidth: .infinity)
                        }
                    }
                } footer: {
                    Text(viewModel.loggedInAs)
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { dismiss() }) {
                        Text("Done")
                    }
                }
            }
            .sheet(isPresented: $isShowSignUpDialogPresented) {
                AuthenticationView()
            }
        }
    }
}

#Preview {
    SettingsView()
}
