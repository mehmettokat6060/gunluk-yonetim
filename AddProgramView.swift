import SwiftUI

struct AddProgramView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var date = Date()
    @State private var person = ""
    @State private var location = ""
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Program") {
                    TextField("Program başlığı", text: $title)
                    DatePicker("Tarih ve saat", selection: $date)
                }
                Section("Detaylar") {
                    TextField("Görüşülecek kişi", text: $person)
                    TextField("Konum", text: $location)
                    TextField("Not", text: $note, axis: .vertical)
                }
                Section {
                    Button {
                        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !cleanTitle.isEmpty else { return }
                        store.addProgram(title: cleanTitle, date: date, person: person, location: location, note: note)
                        dismiss()
                    } label: {
                        Text("Programı Kaydet").frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Program Ekle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Kapat") { dismiss() } }
            }
        }
    }
}
