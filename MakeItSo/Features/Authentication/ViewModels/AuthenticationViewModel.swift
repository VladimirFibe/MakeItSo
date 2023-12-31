import Foundation
import Combine
import Factory
import FirebaseCore
import FirebaseAuth
import AuthenticationServices

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signup
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Injected(\.authenticationService) var authenticationService
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var flow: AuthenticationFlow = .signup
    @Published var isOtherAuthOptionsVisible = false
    @Published var isValid = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var user: User? = nil
    @Published var displayName = ""
    @Published var isGuestUser = false
    @Published var isVerified = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(flow: AuthenticationFlow = .signup) {
        self.flow = flow
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
        
        $user
            .compactMap { $0?.displayName ?? $0?.email ?? ""}
            .assign(to: &$displayName)
        
        $user
            .compactMap { $0?.isAnonymous }
            .assign(to: &$isGuestUser)
        
        $user
            .compactMap { $0?.isEmailVerified }
            .assign(to: &$isVerified)
    }
    
    func switchFlow() {
        flow = flow == .login ? .signup : .login
        errorMessage = ""
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
    
    // MARK: - Account Deletion

    func deleteAccount() async -> Bool {
        await authenticationService.deleteAccount()
    }

    // MARK: - Signing out

    func signOut() {
        authenticationService.signOut()
    }
    
    
}

// MARK: - Sign in with Apple
extension AuthenticationViewModel {
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        authenticationService.handleSignInWithAppleRequest(request)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async -> Bool {
        await authenticationService.handleSignInWithAppleCompletion(result, withAccountLinking: true)
    }
}
