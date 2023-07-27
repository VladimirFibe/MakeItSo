import SwiftUI

struct RemindersListRowView: View {
    @Binding var reminder: Reminder
    var body: some View {
        HStack {
            Toggle(isOn: $reminder.isCompleted) {
                
            }
            .toggleStyle(.reminder)
            Text(reminder.title)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct ContainerForReminder: View {
    @State private var reminder = Reminder.samples[0]
    var body: some View {
        List {
            RemindersListRowView(reminder: $reminder)
        }
    }
}

#Preview {
    ContainerForReminder()
}
