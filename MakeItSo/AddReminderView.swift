import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var reminder = Reminder(title: "")
    enum FocusableField: Hashable {
        case title
    }
    @FocusState private var focusedField: FocusableField?
    var onCommit: (_ reminder: Reminder) -> Void
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $reminder.title)
                    .focused($focusedField, equals: .title)
            }
            .navigationTitle("New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: commit) {
                        Text("Add")
                    }
                    .disabled(reminder.title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: cancel) {
                        Text("Cancel")
                    }
                }
            }
            .onAppear { focusedField = .title}
        }
    }
    
    private func commit() {
        onCommit(reminder)
        dismiss()
    }
    
    private func cancel() {
        dismiss()
    }
}

#Preview {
    AddReminderView(onCommit: { reminder in print(reminder.title)})
}
