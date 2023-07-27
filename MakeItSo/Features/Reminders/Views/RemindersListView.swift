import SwiftUI

struct RemindersListView: View {
    @StateObject var viewModel = RemindersListViewModel()
    @State private var isAddReminderDialogPresented = false
    @State private var editableReminder: Reminder? = nil
    @State private var isSettingsScreenPresented = false
    var body: some View {
        List($viewModel.reminders) { $reminder in
            RemindersListRowView(reminder: $reminder)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive, action: {
                        viewModel.deleteReminder(reminder)
                    }) {
                        Image(systemName: "trash")
                    }
                }
                .onChange(of: reminder.isCompleted) { _, newValue in
                    viewModel.setCompleted(reminder, isCompleted: newValue)
                }
                .onTapGesture {
                    editableReminder = reminder
                }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: presentSettingsScreen) {
                    Image(systemName: "gearshape")
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: presentAddReminderView) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Reminder").foregroundStyle(.black)
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $isAddReminderDialogPresented, content: {
            EditReminderDetailsView { reminder in
                viewModel.addReminder(reminder)
            }
        })
        .sheet(item: $editableReminder) { reminder in
            EditReminderDetailsView(mode: .edit, reminder: reminder) { reminder in
                viewModel.updateReminder(reminder)
            }
        }
        .sheet(isPresented: $isSettingsScreenPresented) {
            SettingsView()
        }
    }
    
    private func presentSettingsScreen() {
        isSettingsScreenPresented.toggle()
    }

    private func presentAddReminderView() {
        isAddReminderDialogPresented.toggle()
    }
}

#Preview {
    NavigationStack {
        RemindersListView()
    }
}
