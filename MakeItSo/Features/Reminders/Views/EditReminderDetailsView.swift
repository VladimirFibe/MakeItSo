import SwiftUI

struct EditReminderDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    enum Mode {
        case add
        case edit
    }
    var mode: Mode = .add
    @State var reminder = Reminder(title: "")
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
                    .onSubmit { commit() }
            }
            .navigationTitle(mode == .add ? "New Reminder" : "Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: commit) {
                        Text(mode == .add ? "Add" : "Done")
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
struct ContainerForDetailView: View {
    @State var reminder = Reminder.samples[0]
    var body: some View {
        EditReminderDetailsView(mode: .edit, reminder: reminder) { reminder in
            print(reminder.title)
        }
    }
}
#Preview {
    ContainerForDetailView()
}
