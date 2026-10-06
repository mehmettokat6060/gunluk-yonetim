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
                DatePicker(
                    "Tarih",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding(.horizontal)

                Divider()

                if selectedPrograms.isEmpty {
                    ContentUnavailableView(
                        "Program Yok",
                        systemImage: "calendar.badge.plus",
                        description: Text("Bu gün için kayıtlı program bulunmuyor.")
                    )
                } else {
                    List(selectedPrograms) { program in
                        ProgramRow(program: program)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                }
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
            }
        }
    }
}
