import SwiftUI

struct AddProgramView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var person = ""
    @State private var location = ""
    @State private var date = Date()
    @State private var priority = "Normal"

    private let priorities = ["Düşük", "Normal", "Yüksek"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Program") {
                    TextField("Başlık", text: $title)
                    TextField("Kişi / Kurum", text: $person)
                    TextField("Yer", text: $location)
                    DatePicker("Tarih ve saat", selection: $date)
                    Picker("Öncelik", selection: $priority) {
                        ForEach(priorities, id: \.self) { value in
                            Text(value).tag(value)
                        }
                    }
                }

                Section {
                    Button("Kaydet") {
                        let finalTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !finalTitle.isEmpty else { return }

                        store.addProgram(
                            ProgramItem(
                                title: finalTitle,
                                date: date,
                                person: person,
                                location: location,
                                priority: priority
                            )
                        )
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Program Ekle")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
        }
    }
}
