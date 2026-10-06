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

    init(id: UUID = UUID(), title: String, date: Date, location: String = "", person: String = "", note: String = "", completed: Bool = false) {
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

    init(id: UUID = UUID(), title: String, dueDate: Date, priority: String = "Normal", completed: Bool = false) {
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

    init(id: UUID = UUID(), title: String, dueDate: Date, responsible: String = "", status: String = "Bekliyor") {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.responsible = responsible
        self.status = status
    }
}

final class AppStore: ObservableObject {
    @Published var programs: [ProgramItem] = [
        ProgramItem(title: "Kurum içi toplantı", date: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(), location: "VIP Toplantı Salonu"),
        ProgramItem(title: "Ziyaret", date: Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? Date(), person: "Ahmet Bey", location: "Merkez"),
        ProgramItem(title: "Saha programı", date: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date()) ?? Date(), location: "Turhal")
    ]

    @Published var tasks: [TaskItem] = [
        TaskItem(title: "Ahmet Bey'i ara", dueDate: Date(), priority: "Önemli"),
        TaskItem(title: "Toplantı notlarını kontrol et", dueDate: Date())
    ]

    @Published var instructions: [InstructionItem] = [
        InstructionItem(title: "Çöreğibüyük yolu incelenecek", dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(), responsible: "Mehmet"),
        InstructionItem(title: "İhale konusu araştırılacak", dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(), responsible: "Ahmet", status: "Devam ediyor")
    ]

    func addProgram(title: String, date: Date, person: String, location: String, note: String) {
        programs.append(ProgramItem(title: title, date: date, location: location, person: person, note: note))
        programs.sort { $0.date < $1.date }
    }

    func toggleTask(_ task: TaskItem) {
        if let i = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[i].completed.toggle()
        }
    }
}

struct AICommandResult {
    var message: String
    var shouldAddProgram: Bool
    var title: String
    var date: Date
}

final class AICommandParser {
    static func parse(_ input: String) -> AICommandResult {
        let lower = input.lowercased()
        let calendar = Calendar.current
        let now = Date()
        var targetDate = now

        if lower.contains("yarın") {
            targetDate = calendar.date(byAdding: .day, value: 1, to: now) ?? now
        } else if lower.contains("öbür gün") {
            targetDate = calendar.date(byAdding: .day, value: 2, to: now) ?? now
        }

        var hour = 9
        var minute = 0
        let pattern = #"(\d{1,2})(?:[:.](\d{2}))?"#
        if let match = lower.range(of: pattern, options: .regularExpression) {
            let raw = String(lower[match]).replacingOccurrences(of: ".", with: ":")
            let parts = raw.split(separator: ":")
            hour = Int(parts.first ?? "9") ?? 9
            if parts.count > 1 { minute = Int(parts[1]) ?? 0 }
        }
        if lower.contains("öğleden sonra") && hour < 12 { hour += 12 }
        if lower.contains("akşam") && hour < 12 { hour += 12 }

        targetDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: targetDate) ?? targetDate

        let isProgram = ["ekle", "oluştur", "programa yaz", "programa ekle", "randevu oluştur"]
            .contains { lower.contains($0) }

        var title = "Yeni Program"
        if lower.contains("toplantı") { title = "Toplantı" }
        else if lower.contains("ziyaret") { title = "Ziyaret" }
        else if lower.contains("saha") { title = "Saha programı" }
        else if let range = lower.range(of: "ile görüşme") {
            let before = String(input[..<range.lowerBound])
            let words = before.split(separator: " ")
            if let last = words.last { title = "\(last) ile görüşme" }
        }

        if isProgram {
            return AICommandResult(
                message: "Programı hazırladım: \(targetDate.formatted(date: .abbreviated, time: .shortened)) — \(title).",
                shouldAddProgram: true,
                title: title,
                date: targetDate
            )
        }

        return AICommandResult(
            message: "Şimdilik “yarın saat 10'da Ahmet Bey ile görüşme ekle” gibi bir komut kullanabilirsiniz.",
            shouldAddProgram: false,
            title: title,
            date: targetDate
        )
    }
}
