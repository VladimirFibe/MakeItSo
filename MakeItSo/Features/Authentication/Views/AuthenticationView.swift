import SwiftUI
import Combine

struct AuthenticationView: View {
    @StateObject var viewModel = AuthenticationViewModel()
    var body: some View {
        VStack {
            switch viewModel.flow {
            case .login:
                LoginView()
                    .environmentObject(viewModel)
            case .signup:
                SignupView()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    AuthenticationView()
}
