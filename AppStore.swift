import Foundation
import Combine

struct ProgramItem: Identifiable, Hashable {
    let id: UUID
    var title: String
    var date: Date
    var person: String
    var location: String
    var priority: String

    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        person: String = "",
        location: String = "",
        priority: String = "Normal"
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.person = person
        self.location = location
        self.priority = priority
    }
}

struct TaskItem: Identifiable, Hashable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var priority: String

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        priority: String = "Normal"
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
    }
}

struct InstructionItem: Identifiable, Hashable {
    let id: UUID
    var title: String
    var detail: String
    var date: Date
    var isCompleted: Bool

    init(
        id: UUID = UUID(),
        title: String,
        detail: String = "",
        date: Date = Date(),
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.date = date
        self.isCompleted = isCompleted
    }
}

final class AppStore: ObservableObject {
    @Published var programs: [ProgramItem] = [
        ProgramItem(
            title: "Günün programı",
            date: Calendar.current.date(bySettingHour: 09, minute: 00, second: 0, of: Date()) ?? Date(),
            person: "",
            location: "",
            priority: "Normal"
        )
    ]

    @Published var tasks: [TaskItem] = [
        TaskItem(title: "Bugünün önemli işlerini kontrol et", priority: "Yüksek"),
        TaskItem(title: "Bekleyen talimatları gözden geçir", priority: "Normal")
    ]

    @Published var instructions: [InstructionItem] = [
        InstructionItem(title: "Örnek talimat", detail: "Bu alan yönetici talimatları için kullanılacak.")
    ]

    func addProgram(_ program: ProgramItem) {
        programs.append(program)
        programs.sort { $0.date < $1.date }
    }

    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }

    func toggleTask(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isCompleted.toggle()
    }

    func addInstruction(_ instruction: InstructionItem) {
        instructions.append(instruction)
    }

    var todayPrograms: [ProgramItem] {
        programs.filter { Calendar.current.isDateInToday($0.date) }
            .sorted { $0.date < $1.date }
    }
}
