import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var store: AppStore
    @State private var selectedDate = Date()
    @State private var showingAdd = false

    private var selectedPrograms: [ProgramItem] {
        store.programs
            .filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                DatePicker("Tarih", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)

                List {
                    Section(header: Text(sectionTitle)) {
                        if selectedPrograms.isEmpty {
                            Text("Bu gün için program bulunmuyor.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(selectedPrograms) { item in
                                ProgramRow(item: item)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Takvim")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddProgramView()
                    .environmentObject(store)
            }
        }
    }

    private var sectionTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: selectedDate).capitalized
    }
}
