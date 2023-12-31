import SwiftUI
import Factory
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct MakeItSoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RemindersListView()
                    .navigationTitle("Reminders")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    @LazyInjected(\.authenticationService) private var authenticationService
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        authenticationService.signInAnonymously()
        return true
    }
}
