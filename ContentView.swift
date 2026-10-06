import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }

            CalendarView()
                .tabItem {
                    Label("Takvim", systemImage: "calendar")
                }

            AIAssistantView()
                .tabItem {
                    Label("Asistan", systemImage: "sparkles")
                }

            TasksView()
                .tabItem {
                    Label("İşler", systemImage: "checklist")
                }

            MoreView()
                .tabItem {
                    Label("Diğer", systemImage: "ellipsis.circle")
                }
        }
    }
}
