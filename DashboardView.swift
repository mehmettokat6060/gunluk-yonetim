import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showingAdd = false

    private var todayPrograms: [ProgramItem] {
        store.programs.filter { Calendar.current.isDateInToday($0.date) }.sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting)
                            .font(.title2.weight(.semibold))
                        Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 12) {
                        SummaryCard(title: "Program", value: "\(todayPrograms.count)", icon: "calendar")
                        SummaryCard(title: "Bekleyen İş", value: "\(store.tasks.filter { !$0.completed }.count)", icon: "checkmark.circle")
                    }

                    HStack(spacing: 12) {
                        SummaryCard(title: "Talimat", value: "\(store.instructions.filter { $0.status != "Tamamlandı" }.count)", icon: "pin")
                        SummaryCard(title: "Geciken", value: "\(store.instructions.filter { $0.dueDate < Date() && $0.status != "Tamamlandı" }.count)", icon: "exclamationmark.triangle")
                    }

                    HStack {
                        Text("Bugünkü Program")
                            .font(.title3.bold())
                        Spacer()
                        Button("Tümü") {}
                            .font(.subheadline.weight(.semibold))
                    }

                    if todayPrograms.isEmpty {
                        ContentUnavailableView("Bugün program yok", systemImage: "calendar.badge.plus")
                    } else {
                        ForEach(todayPrograms) { item in
                            ProgramRow(item: item)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Yönetici Asistanı")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Program ekle")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddProgramView()
                    .environmentObject(store)
            }
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Günaydın 👋" }
        if hour < 18 { return "İyi günler 👋" }
        return "İyi akşamlar 👋"
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
            Text(value)
                .font(.title.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct ProgramRow: View {
    let item: ProgramItem

    var body: some View {
        HStack(spacing: 14) {
            Text(item.date.formatted(date: .omitted, time: .shortened))
                .font(.headline)
                .frame(width: 62, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.body.weight(.semibold))
                if !item.person.isEmpty {
                    Text(item.person)
                        .foregroundStyle(.secondary)
                }
                if !item.location.isEmpty {
                    Label(item.location, systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.quaternary))
    }
}
