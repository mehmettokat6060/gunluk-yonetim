import SwiftUI

struct MoreView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Aranacaklar", systemImage: "phone") {
                    PlaceholderView(title: "Aranacaklar", icon: "phone")
                }
                NavigationLink("Notlar", systemImage: "note.text") {
                    PlaceholderView(title: "Notlar", icon: "note.text")
                }
                NavigationLink("AI Asistan", systemImage: "sparkles") {
                    AIAssistantView()
                        .environmentObject(store)
                }
                NavigationLink("Yönetici Hafızası", systemImage: "brain.head.profile") {
                    PlaceholderView(title: "Yönetici Hafızası", icon: "brain.head.profile")
                }
                NavigationLink("Aylık Program / PDF", systemImage: "doc.richtext") {
                    PlaceholderView(title: "Aylık Program / PDF", icon: "doc.richtext")
                }
            }
            .navigationTitle("Daha Fazla")
        }
    }
}

struct PlaceholderView: View {
    let title: String
    let icon: String

    var body: some View {
        ContentUnavailableView(title, systemImage: icon, description: Text("Bu bölüm MVP'nin sonraki adımında geliştirilecek."))
            .navigationTitle(title)
    }
}
