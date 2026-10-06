import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showingAddProgram = false

    private var todayText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: Date()).capitalized
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Yönetici Asistanı")
                            .font(.largeTitle.bold())
                        Text(todayText)
                            .foregroundStyle(.secondary)
                        Text("Gününüzü yönetin, hiçbir işi unutmayın.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 12) {
                        summaryCard(
                            title: "Bugün",
                            value: "\(store.todayPrograms.count)",
                            subtitle: "program",
                            systemImage: "calendar"
                        )
                        summaryCard(
                            title: "Bekleyen",
                            value: "\(store.tasks.filter { !$0.isCompleted }.count)",
                            subtitle: "iş",
                            systemImage: "checklist"
                        )
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Bugünün Programı")
                                .font(.title3.bold())
                            Spacer()
                            Button("Ekle") {
                                showingAddProgram = true
                            }
                        }

                        if store.todayPrograms.isEmpty {
                            Text("Bugün için kayıtlı program yok.")
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 12)
                        } else {
                            ForEach(store.todayPrograms) { program in
                                ProgramRow(program: program)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Hızlı İşlemler")
                            .font(.title3.bold())

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            quickButton("Program Ekle", "plus.circle.fill") {
                                showingAddProgram = true
                            }
                            NavigationLink {
                                TasksView()
                            } label: {
                                QuickActionLabel(title: "İşler", systemImage: "checklist")
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddProgram) {
                AddProgramView()
            }
        }
    }

    private func summaryCard(title: String, value: String, subtitle: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: systemImage)
                .font(.title2)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title.bold())
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func quickButton(_ title: String, _ systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            QuickActionLabel(title: title, systemImage: systemImage)
        }
        .buttonStyle(.plain)
    }
}

struct QuickActionLabel: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
            Text(title)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}

struct ProgramRow: View {
    let program: ProgramItem

    var body: some View {
        HStack(spacing: 12) {
            Text(program.date.formatted(date: .omitted, time: .shortened))
                .font(.headline)
                .frame(width: 58, alignment: .leading)

            VStack(alignment: .leading, spacing: 3) {
                Text(program.title)
                    .fontWeight(.semibold)
                if !program.person.isEmpty {
                    Text(program.person)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if !program.location.isEmpty {
                    Text(program.location)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}
