import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    InstructionsView()
                } label: {
                    Label("Talimatlar", systemImage: "text.book.closed")
                }

                NavigationLink {
                    ExecutiveMemoryView()
                } label: {
                    Label("Yönetici Hafızası", systemImage: "brain.head.profile")
                }

                NavigationLink {
                    MonthlyProgramView()
                } label: {
                    Label("Aylık Program / PDF", systemImage: "doc.richtext")
                }

                Label("Notlar", systemImage: "note.text")
                Label("Aramalar", systemImage: "phone")
            }
            .navigationTitle("Diğer")
        }
    }
}

struct ExecutiveMemoryView: View {
    var body: some View {
        List {
            Section("Yönetici Hafızası") {
                Text("Kişiler, kurumlar, önemli notlar ve önceki görüşmeler bu bölümde tutulacak.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Yönetici Hafızası")
    }
}

struct MonthlyProgramView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.richtext")
                .font(.system(size: 48))
            Text("Aylık Program")
                .font(.title2.bold())
            Text("Bu bölümde aylık programın PDF olarak hazırlanması eklenecek.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Aylık Program")
    }
}
