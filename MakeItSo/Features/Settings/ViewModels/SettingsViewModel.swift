import Foundation
import Factory
import FirebaseAuth
import Combine

class SettingsViewModel: ObservableObject {
    @Injected(\.authenticationService) private var authenticationService
    @Published var user: User?
    @Published var displayName = ""
    @Published var isGuestUser = false
    @Published var loggedInAs = ""
    
    init() {
        authenticationService.$user
            .assign(to: &$user)
        $user
            .compactMap { $0?.isAnonymous }
            .assign(to: &$isGuestUser)
        
        $user
            .compactMap { $0?.displayName ?? $0?.email ?? ""}
            .assign(to: &$displayName)
        
        Publishers.CombineLatest($isGuestUser, $displayName)
            .map { isGuest, displayName in
            isGuest ? "You're using the app as a guest"
                : "Logged in as \(displayName)"
            }
            .assign(to: &$loggedInAs)
    }
    
    func signOut() {
        authenticationService.signOut()
    }
}
