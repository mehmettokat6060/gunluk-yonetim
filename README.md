# Yönetici Asistanı v0.4

SwiftUI tabanlı iOS MVP prototipi.

Bu sürüm önceki derleme sorunlarını azaltmak için kaynak dosyaları baştan ve tutarlı şekilde düzenler. Özellikle `ProgramItem` çağrılarında isimli parametre sırası tek biçime getirildi ve AI Asistan program eklerken kişi bilgisini de korur.

GitHub Actions üzerinde XcodeGen ile Xcode projesi oluşturulur ve iOS Simulator hedefi için imzasız derleme yapılır.

Not: Bu workflow yalnızca derleme testi yapar. Gerçek iPhone kurulumu/TestFlight için Apple Developer imzalama ve App Store Connect kurulumu ayrıca gerekir.
