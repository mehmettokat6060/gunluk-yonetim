import Foundation
import SwiftUI

struct ProgramItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var date: Date
    var location: String
    var person: String
    var note: String
    var completed: Bool

    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        location: String = "",
        person: String = "",
        note: String = "",
        completed: Bool = false
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.location = location
        self.person = person
        self.note = note
        self.completed = completed
    }
}

struct TaskItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var dueDate: Date
    var priority: String
    var completed: Bool

    init(
        id: UUID = UUID(),
        title: String,
        dueDate: Date,
        priority: String = "Normal",
        completed: Bool = false
    ) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.completed = completed
    }
}

struct InstructionItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var dueDate: Date
    var responsible: String
    var status: String

    init(
        id: UUID = UUID(),
        title: String,
        dueDate: Date,
        responsible: String = "",
        status: String = "Bekliyor"
    ) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.responsible = responsible
        self.status = status
    }
}

final class AppStore: ObservableObject {
    @Published var programs: [ProgramItem] = []
    @Published var tasks: [TaskItem] = []
    @Published var instructions: [InstructionItem] = []

    init() {
        seedDemoData()
    }

    private func seedDemoData() {
        let calendar = Calendar.current
        let today = Date()

        programs = [
            ProgramItem(
                title: "Kurum içi toplantı",
                date: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today) ?? today,
                location: "VIP Toplantı Salonu"
            ),
            ProgramItem(
                title: "Ziyaret",
                date: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: today) ?? today,
                location: "Merkez",
                person: "Ahmet Bey"
            ),
            ProgramItem(
                title: "Saha programı",
                date: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: today) ?? today,
                location: "Turhal"
            )
        ]

        tasks = [
            TaskItem(title: "Ahmet Bey'i ara", dueDate: today, priority: "Önemli"),
            TaskItem(title: "Toplantı notlarını kontrol et", dueDate: today)
        ]

        instructions = [
            InstructionItem(
                title: "Çöreğibüyük yolu incelenecek",
                dueDate: calendar.date(byAdding: .day, value: 2, to: today) ?? today,
                responsible: "Mehmet"
            ),
            InstructionItem(
                title: "İhale konusu araştırılacak",
                dueDate: calendar.date(byAdding: .day, value: 3, to: today) ?? today,
                responsible: "Ahmet",
                status: "Devam ediyor"
            )
        ]
    }

    func addProgram(title: String, date: Date, person: String = "", location: String = "", note: String = "") {
        let item = ProgramItem(
            title: title,
            date: date,
            location: location,
            person: person,
            note: note
        )
        programs.append(item)
        programs.sort { $0.date < $1.date }
    }

    func toggleTask(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].completed.toggle()
    }
}

struct AICommandResult {
    var message: String
    var shouldAddProgram: Bool
    var title: String
    var person: String
    var date: Date
}

final class AICommandParser {
    static func parse(_ input: String) -> AICommandResult {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = trimmed.lowercased(with: Locale(identifier: "tr_TR"))
        let calendar = Calendar.current
        let now = Date()

        var targetDate = now
        if lower.contains("öbür gün") {
            targetDate = calendar.date(byAdding: .day, value: 2, to: now) ?? now
        } else if lower.contains("yarın") {
            targetDate = calendar.date(byAdding: .day, value: 1, to: now) ?? now
        }

        var hour = 9
        var minute = 0
        let pattern = #"\b(\d{1,2})(?:[:.](\d{2}))?\b"#
        if let match = lower.range(of: pattern, options: .regularExpression) {
            let raw = String(lower[match]).replacingOccurrences(of: ".", with: ":")
            let parts = raw.split(separator: ":")
            if let first = parts.first, let parsedHour = Int(first) {
                hour = parsedHour
            }
            if parts.count > 1, let parsedMinute = Int(parts[1]) {
                minute = parsedMinute
            }
        }

        if lower.contains("öğleden sonra") && hour < 12 { hour += 12 }
        if lower.contains("akşam") && hour < 12 { hour += 12 }
        if lower.contains("sabah") && hour == 12 { hour = 0 }
        hour = min(max(hour, 0), 23)
        minute = min(max(minute, 0), 59)

        targetDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: targetDate) ?? targetDate

        let shouldAdd = lower.contains("ekle") || lower.contains("oluştur") || lower.contains("yaz")
        var title = "Yeni Program"
        var person = ""

        if let range = lower.range(of: "ile görüşme") {
            let before = String(trimmed[..<range.lowerBound])
            let cleaned = before
                .replacingOccurrences(of: "yarın", with: "", options: .caseInsensitive)
                .replacingOccurrences(of: "öbür gün", with: "", options: .caseInsensitive)
                .replacingOccurrences(of: "saat", with: "", options: .caseInsensitive)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let words = cleaned.split(separator: " ")
            if words.count >= 2 {
                person = words.suffix(2).joined(separator: " ")
            } else if let first = words.last {
                person = String(first)
            }
            title = "Görüşme"
        } else if lower.contains("toplantı") {
            title = "Toplantı"
        } else if lower.contains("ziyaret") {
            title = "Ziyaret"
        } else if lower.contains("saha") {
            title = "Saha programı"
        }

        if shouldAdd {
            var detail = targetDate.formatted(date: .abbreviated, time: .shortened)
            if !person.isEmpty {
                detail += " — \(person)"
            }
            return AICommandResult(
                message: "Programı hazırladım: \(detail).",
                shouldAddProgram: true,
                title: title,
                person: person,
                date: targetDate
            )
        }

        return AICommandResult(
            message: "Örnek: “Yarın saat 10'da Ahmet Bey ile görüşme ekle”.",
            shouldAddProgram: false,
            title: title,
            person: person,
            date: targetDate
        )
    }
}
