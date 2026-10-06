import SwiftUI

struct AIAssistantView: View {
    @EnvironmentObject private var store: AppStore
    @State private var command = ""
    @State private var result: AICommandResult?
    @State private var showSaved = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 42))
                    Text("Yapay Zekâ Asistanı")
                        .font(.title2.bold())
                    Text("Programınızı doğal cümlelerle yönetin.")
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Örnek komutlar").font(.headline)
                        ExampleCommand(text: "Yarın saat 10'da Ahmet Bey ile görüşme ekle") {
                            command = "Yarın saat 10'da Ahmet Bey ile görüşme ekle"
                        }
                        ExampleCommand(text: "Yarın 14.00'te toplantı ekle") {
                            command = "Yarın 14.00'te toplantı ekle"
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let result {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(result.message)
                        if result.shouldAddProgram {
                            Button {
                                store.addProgram(
                                    title: result.title,
                                    date: result.date,
                                    person: "",
                                    location: "",
                                    note: "AI Asistan ile oluşturuldu"
                                )
                                showSaved = true
                            } label: {
                                Label("Programa Ekle", systemImage: "calendar.badge.plus")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }

                HStack(alignment: .bottom, spacing: 10) {
                    TextField("Komutunuzu yazın...", text: $command, axis: .vertical)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        result = AICommandParser.parse(command)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 34))
                    }
                    .disabled(command.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .padding()
            .navigationTitle("AI Asistan")
            .alert("Program eklendi", isPresented: $showSaved) {
                Button("Tamam", role: .cancel) {}
            }
        }
    }
}

struct ExampleCommand: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "text.bubble")
                Text(text).multilineTextAlignment(.leading)
                Spacer()
            }
            .padding()
            .background(.background, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.quaternary))
        }
        .buttonStyle(.plain)
    }
}
