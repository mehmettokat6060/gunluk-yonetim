import SwiftUI

struct TasksView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        NavigationStack {
            List {
                Section("Bekleyen Görevler") {
                    ForEach(store.tasks) { task in
                        HStack {
                            Button {
                                store.toggleTask(task)
                            } label: {
                                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                            }
                            .buttonStyle(.plain)

                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough(task.completed)
                                Text("Son tarih: \(task.dueDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(task.priority)
                                .font(.caption.weight(.semibold))
                        }
                    }
                }
            }
            .navigationTitle("Görevler")
        }
    }
}
