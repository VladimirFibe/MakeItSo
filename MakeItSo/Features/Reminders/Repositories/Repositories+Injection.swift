import Foundation
import Factory

extension Container {
    public var reminderRepository: Factory<ReminderRepository> {
        self {
            ReminderRepository()
        }.singleton
    }
}
