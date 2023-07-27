import Foundation
import Factory
import Combine

final class RemindersListViewModel: ObservableObject {
    @Published var reminders = [Reminder]()
    @Published var errorMessage: String?
    @Injected(\.reminderRepository) private var reminderRepository: ReminderRepository
    
    init() {
        reminderRepository
            .$reminders
            .assign(to: &$reminders)
    }
    func addReminder(_ reminder: Reminder) {
        do {
            try reminderRepository.addReminder(reminder)
            errorMessage = nil
        } catch {
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
    func updateReminder(_ reminder: Reminder) {
        do {
            try reminderRepository.updateReminder(reminder)
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func setCompleted(_ reminder: Reminder, isCompleted: Bool) {
        var editedReminder = reminder
        editedReminder.isCompleted = isCompleted
        updateReminder(editedReminder)
    }
    
    func deleteReminder(_ reminder: Reminder) {
        reminderRepository.removeReminder(reminder)
    }
}
