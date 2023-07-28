import SwiftUI
import Factory
import Combine
import FirebaseAuth

class UserProfileViewModel: ObservableObject {
    @Injected(\.authenticationService) private var authenticationService
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessge = ""
    @Published var user: User?
    @Published var provider = ""
    @Published var displayName = ""
    @Published var email = ""
    @Published var isGuestUser = false
    @Published var isVerified = false
    
    init() {
        authenticationService
            .$user
            .assign(to: &$user)
        $user
            .compactMap { $0?.isAnonymous }
            .assign(to: &$isGuestUser)
        
        $user
            .compactMap { $0?.isEmailVerified }
            .assign(to: &$isVerified)
        
        $user
            .map { $0?.displayName ?? "N/A"}
            .assign(to: &$displayName)
        
        $user
            .map { $0?.email ?? "N/A"}
            .assign(to: &$email)
        
        $user
            .compactMap {
                if let providerData = $0?.providerData.first {
                    return providerData.providerID
                } else {
                    return $0?.providerID
                }
            }
            .assign(to: &$provider)
    }
    
    func deleteAccount() async -> Bool {
        await authenticationService.deleteAccount()
    }
    
    func signOut() {
        authenticationService.signOut()
    }
}
