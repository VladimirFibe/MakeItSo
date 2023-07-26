import SwiftUI

struct RemindersListView: View {
    @StateObject var viewModel = RemindersListViewModel()
    @State private var isAddReminderDialogPresented = false
    var body: some View {
        List(viewModel.reminders) { reminder in
            HStack {
                Image(systemName: reminder.isCompleted ? "largecircle.fill.circle" : "circle")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .onTapGesture {
                        viewModel.toggleCompleted(reminder)
                    }
                Text(reminder.title)
            }
        }
        .toolbar {
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
            AddReminderView { reminder in
                viewModel.addReminder(reminder)
            }
        })
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
