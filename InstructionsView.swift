import SwiftUI

struct InstructionsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var newInstruction = ""

    var body: some View {
        List {
            Section("Yeni Talimat") {
                HStack {
                    TextField("Talimat yazın", text: $newInstruction)
                    Button {
                        addInstruction()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newInstruction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }

            Section("Talimatlar") {
                ForEach(store.instructions) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.title)
                            .fontWeight(.semibold)
                        if !item.detail.isEmpty {
                            Text(item.detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Talimatlar")
    }

    private func addInstruction() {
        let value = newInstruction.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return }
        store.addInstruction(InstructionItem(title: value))
        newInstruction = ""
    }
}
