# Yönetici Asistanı v0.3

SwiftUI tabanlı iOS MVP prototipi.

Bu sürümde:
- Ana sayfa
- Takvim
- Program ekleme
- Görevler
- Talimatlar
- AI Asistan prototipi
- Yönetici hafızası için temel menü
- GitHub Actions üzerinde macOS/Xcode ile otomatik derleme

## GitHub Actions
`project.yml` dosyası XcodeGen ile gerçek Xcode projesi üretir. `.github/workflows/ios-build.yml` ise iOS Simulator hedefi için imzasız derleme yapar.

Bu yöntem uygulamayı App Store'a yüklemez; yalnızca kodun derlenebilir olduğunu test eder. TestFlight/App Store için daha sonra Apple Developer imzalama ve App Store Connect kurulumu gerekir.
