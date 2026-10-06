import SwiftUI

struct TasksView: View {
    @EnvironmentObject private var store: AppStore
    @State private var newTask = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Yeni İş") {
                    HStack {
                        TextField("Yapılacak işi yazın", text: $newTask)
                        Button {
                            addTask()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newTask.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }

                Section("İşler") {
                    ForEach(store.tasks) { task in
                        Button {
                            store.toggleTask(task)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(task.title)
                                        .strikethrough(task.isCompleted)
                                        .foregroundStyle(task.isCompleted ? .secondary : .primary)

                                    Text(task.priority)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("İşler")
        }
    }

    private func addTask() {
        let value = newTask.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return }
        store.addTask(TaskItem(title: value))
        newTask = ""
    }
}
