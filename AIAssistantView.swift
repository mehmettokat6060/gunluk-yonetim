import SwiftUI

struct AIAssistantView: View {
    @EnvironmentObject private var store: AppStore
    @State private var input = ""
    @State private var response = "Merhaba. Bana bir program veya iş yazabilirsiniz.\n\nÖrnek: “Yarın saat 10'da Ahmet Bey ile görüşme ekle.”"

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                ScrollView {
                    Text(response)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                }

                HStack {
                    TextField("Asistana yazın…", text: $input, axis: .vertical)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        processInput()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                    }
                    .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .navigationTitle("AI Asistan")
        }
    }

    private func processInput() {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        if let hour = extractHour(from: text) {
            let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
            let title = makeTitle(from: text)
            store.addProgram(
                ProgramItem(
                    title: title,
                    date: date,
                    person: extractPerson(from: text)
                )
            )
            response = "Programı ekledim:\n\n\(title)\n\(date.formatted(date: .abbreviated, time: .shortened))"
        } else {
            response = "Şimdilik program ekleme komutlarını destekliyorum. Örnek:\n“Yarın saat 10'da Ahmet Bey ile görüşme ekle.”"
        }

        input = ""
    }

    private func extractHour(from text: String) -> Int? {
        let pattern = #"(\d{1,2})(?:[:.](\d{2}))?\s*(?:'|’)?da|(\d{1,2})(?:[:.](\d{2}))?"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return nil
        }

        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        guard let match = regex.firstMatch(in: text, range: range) else { return nil }

        for index in 1...5 {
            if index <= match.numberOfRanges,
               let matchRange = Range(match.range(at: index), in: text),
               let value = Int(text[matchRange]),
               value >= 0, value <= 23 {
                return value
            }
        }
        return nil
    }

    private func extractPerson(from text: String) -> String {
        let lower = text.lowercased()
        guard let range = lower.range(of: "ile görüş") else { return "" }
        let prefix = String(text[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
        if let start = prefix.range(of: "saat", options: .caseInsensitive) {
            let person = String(prefix[start.upperBound...])
                .trimmingCharacters(in: .whitespaces)
            return person
        }
        return ""
    }

    private func makeTitle(from text: String) -> String {
        if text.lowercased().contains("görüş") {
            return "Görüşme"
        }
        return text
    }
}
