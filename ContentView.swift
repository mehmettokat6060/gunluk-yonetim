import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Ana Sayfa", systemImage: "house.fill") }
            CalendarView()
                .tabItem { Label("Takvim", systemImage: "calendar") }
            TasksView()
                .tabItem { Label("Görevler", systemImage: "checkmark.circle") }
            InstructionsView()
                .tabItem { Label("Talimatlar", systemImage: "pin.fill") }
            MoreView()
                .tabItem { Label("Daha Fazla", systemImage: "ellipsis.circle") }
        }
        .tint(.blue)
    }
}
