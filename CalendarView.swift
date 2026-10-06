import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var store: AppStore
    @State private var selectedDate = Date()
    @State private var showingAdd = false

    var selectedPrograms: [ProgramItem] {
        store.programs.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }.sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("Tarih", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)

                List {
                    Section(selectedDate.formatted(.dateTime.weekday(.wide).day().month(.wide))) {
                        if selectedPrograms.isEmpty {
                            Text("Bu gün için program bulunmuyor.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(selectedPrograms) { ProgramRow(item: $0) }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Takvim")
            .toolbar {
                Button {
                    showingAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddProgramView()
                    .environmentObject(store)
            }
        }
    }
}
