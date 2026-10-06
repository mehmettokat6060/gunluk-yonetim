import SwiftUI

struct InstructionsView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.instructions) { item in
                    VStack(alignment: .leading, spacing: 7) {
                        HStack {
                            Text(item.title)
                                .font(.body.weight(.semibold))
                            Spacer()
                            Text(item.status)
                                .font(.caption.weight(.semibold))
                        }

                        Text("Sorumlu: \(item.responsible)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("Son tarih: \(item.dueDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Talimatlar")
        }
    }
}
