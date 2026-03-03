# 60 Günde YDS — Yabancı Dil Sınavı Hazırlık Uygulaması

YDS'ye 60 günde hazırlanmak isteyenler için günlük kelime öğrenme ve pratik uygulaması.

## Genel Bakış

Bu uygulama, **gün gün** yapılandırılmış kelime listesiyle 60 günde YDS'ye hazırlanmanızı sağlar. Her gün belirli sayıda kelime (eş anlamlıları, örnek cümle ve Türkçe çevirisiyle) sunulur. Kartlar, quiz, çalışma listesi ve boşluk doldurma ile kelimeleri pekiştirirsiniz.

### Özellikler

- **60 günlük program:** Her gün 5–6 kelime, toplamda 300+ kelime
- **Kartlar (Flashcard):** İngilizce ↔ Türkçe yön seçimi, eş anlamlılar ve örnek cümleler
- **Quiz:** Çoktan seçmeli sorularla test
- **Çalışma:** Günün kelimelerini liste halinde incele (eş anlamlı, örnek, çeviri)
- **Boşluk Doldur:** Örnek cümledeki eksik kelimeyi bul

### Platform Desteği

- iOS
- macOS
- visionOS (Apple Vision Pro)

---

## Kurulum ve Çalıştırma

### Gereksinimler

- Xcode 26.2+ (veya proje ayarlarıyla uyumlu sürüm)
- macOS (geliştirme için)
- iOS 26.2+ / macOS 26.2+ (hedef platformlar)

### Adımlar

1. Projeyi klonlayın veya indirin
2. `yds.xcodeproj` dosyasını Xcode ile açın
3. Simülatör veya bağlı cihaz seçin
4. ⌘R ile build alıp uygulamayı çalıştırın

---

## Kelime Verisi

Kelimeler `yds/assets/yds_words.json` dosyasında tutulur. (Firebase entegrasyonu için format uyumludur.)

### JSON Formatı (Firebase Uyumlu)

```json
{
  "id": 1756565206587.3313,
  "day": 1,
  "english": "necessary",
  "turkish": "gerekli",
  "synonyms": "required, essential, needed",
  "example": "It is necessary to have a visa to enter the country.",
  "exampleTurkish": "Ülkeye girmek için vize almak gereklidir."
}
```

| Alan            | Açıklama                                    |
|-----------------|----------------------------------------------|
| `id`            | Benzersiz tanımlayıcı (sayı)                 |
| `day`           | Hangi güne ait (1–60)                        |
| `english`       | İngilizce kelime                             |
| `turkish`       | Türkçe karşılık                             |
| `synonyms`      | Virgülle ayrılmış eş anlamlılar (opsiyonel) |
| `example`       | Örnek cümle                                  |
| `exampleTurkish`| Örnek cümlenin Türkçe çevirisi (opsiyonel)   |

### Günlük İlerleme

- Uygulama `UserDefaults` ile mevcut günü (1–60) kaydeder.
- Ana sayfadan önceki/sonraki güne geçilebilir.
- Tüm pratik modları **o günün kelimeleriyle** çalışır.

---

## Teknik Dokümantasyon

### Mimari

Proje **MVVM benzeri** bir yapı kullanır:

- **Models:** Veri modelleri
- **Services:** Veri yükleme ve işleme
- **Views:** SwiftUI arayüz bileşenleri
- **Theme:** Tasarım sistemi (renkler, tipografi, spacing)

### Proje Yapısı

```
yds/
├── yds/
│   ├── assets/
│   │   ├── yds_words.json         # 60 günlük kelime veritabanı
│   │   └── sample_words.json     # Yedek/örnek kelimeler
│   ├── Models/
│   │   └── Word.swift             # Kelime modeli
│   ├── Services/
│   │   └── WordService.swift      # Kelime servisi
│   ├── Theme/
│   │   └── DesignSystem.swift     # Renkler, tipografi, spacing
│   ├── Views/
│   │   ├── HomeView.swift         # Ana sayfa
│   │   ├── FlashcardView.swift    # Kart modu
│   │   ├── QuizView.swift         # Quiz modu
│   │   ├── StudyView.swift        # Çalışma modu
│   │   └── FillBlankView.swift    # Boşluk doldurma modu
│   ├── ContentView.swift          # Kök view
│   └── ydsApp.swift              # Uygulama giriş noktası
├── yds.xcodeproj/
└── README.md
```

---

## Modüller ve Kod Açıklamaları

### 1. `ydsApp.swift`

Uygulamanın giriş noktası. `@main` ile işaretlenmiş `ydsApp` struct'ı `WindowGroup` içinde `ContentView`'i gösterir.

```swift
@main
struct ydsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

---

### 2. `Theme/DesignSystem.swift`

Tutarlı UI için tasarım sistemi. Renk paleti (background, cardBackground, textPrimary/secondary, mod renkleri), tipografi (SF Rounded), spacing ve corner radius değerleri tanımlar.

---

### 3. `Models/Word.swift`

Kelime veri modeli. `Codable` ile JSON'dan decode edilir; `Identifiable` SwiftUI listelerinde kullanım için, `Equatable` karşılaştırma için sağlanır.

| Özellik       | Tip      | Açıklama                          |
|---------------|----------|------------------------------------|
| `id`          | Double   | Benzersiz ID                       |
| `day`         | Int      | Hangi güne ait (1–60)              |
| `english`     | String   | İngilizce kelime                   |
| `turkish`     | String   | Türkçe karşılık                    |
| `synonyms`    | String?  | Virgülle ayrılmış eş anlamlılar    |
| `example`     | String   | Örnek cümle                        |
| `exampleTurkish` | String? | Örnek cümlenin Türkçe çevirisi   |
| `addedDate`   | String?  | Eklenme tarihi (opsiyonel)         |

---

### 4. `Services/WordService.swift`

Kelime verilerini yükleyen ve yöneten servis sınıfı. `@MainActor` ve `ObservableObject` ile SwiftUI'da reaktif çalışır.

**Özellikler:**
- `allWords: [Word]` — Yüklenen tüm kelime listesi
- `currentDay: Int` — Mevcut gün (1–60)
- `todaysWords: [Word]` — O güne ait kelimeler
- `isLoading: Bool` — Yükleme durumu
- `errorMessage: String?` — Hata mesajı (varsa)

**Metodlar:**
- `loadWords()` — Bundle'dan JSON dosyasını okur, decode eder
- `shuffledWords()` — O günün kelimelerinin karıştırılmış listesi
- `advanceToNextDay()` — Sonraki güne geç
- `goToPreviousDay()` — Önceki güne dön

**Dosya önceliği:** `yds_words.json` → `sample_words.json` (assets klasöründe)

---

### 5. `Views/HomeView.swift`

Ana sayfa. `WordService` ile kelimeleri yükler, günlük ilerlemeyi gösterir ve dört öğrenme moduna geçiş sağlar.

**Bileşenler:**
- `headerSection` — Başlık ve ikon
- `dailyProgressSection` — Gün göstergesi, ilerleme çubuğu, önceki/sonraki gün butonları
- `learningModesSection` — Mod kartları (`LearningModeCard`)
- `LearningModeCard` — Her mod için tıklanabilir kart (title, subtitle, icon, color, destination)

**Modlar:** Kartlar, Quiz, Çalışma, Boşluk Doldur

---

### 6. `Views/FlashcardView.swift`

Flashcard modu. Günün kelimelerini kart şeklinde gösterir, tıklayınca cevabı açar.

**State:**
- `currentIndex` — Görüntülenen kelime indeksi
- `showTurkish` — Cevabın görünürlüğü
- `direction` — İngilizce → Türkçe / Türkçe → İngilizce

**Bileşenler:**
- `progressSection` — İlerleme göstergesi
- `directionPicker` — Yön seçici (İngilizce ↔ Türkçe)
- `cardContent` — Kart (kelime, cevap, eş anlamlılar, örnek cümle, Türkçe çeviri)
- `navigationControls` — Önceki / Sonraki butonları, swipe desteği

---

### 7. `Views/QuizView.swift`

Çoktan seçmeli quiz. Her soruda 4 seçenek sunar; 1 doğru, 3 yanlış.

**Mantık:**
- `currentWord` — Görüntülenen kelime
- `options` — Doğru cevap + diğer kelimelerden 3 yanlış seçenek
- `selectedAnswer` / `showResult` — Kullanıcı cevabı ve sonuç gösterimi

**Koşul:** En az 4 kelime gerekir (1 doğru + 3 yanlış seçenek için).

---

### 8. `Views/StudyView.swift`

Kelimeleri liste halinde gösterir. Arama ve expand/collapse destekler.

**Özellikler:**
- `searchText` — Arama kutusu
- `filteredWords` — Filtrelenmiş liste (İngilizce/Türkçe eşleşmesi)
- `expandedIds` — Genişletilmiş (örnek cümle gösterilen) kelime ID'leri

---

### 9. `Views/FillBlankView.swift`

Örnek cümlede kelimeyi `_____` ile değiştirir; kullanıcı eksik kelimeyi yazarak tamamlar.

**Mantık:**
- `wordsWithExamples` — Sadece `example` alanı dolu kelimeler
- `sentenceWithBlank(for:)` — Kelimeyi `_____` ile değiştirir
- `isAnswerCorrect()` — Büyük/küçük harf ve boşluklara toleranslı karşılaştırma

---

## Teknoloji Stack

| Teknoloji   | Kullanım                     |
|-------------|------------------------------|
| SwiftUI     | UI oluşturma                 |
| Combine     | Reaktif state (@Published)   |
| UserDefaults| Günlük ilerleme (gün 1–60)   |
| Swift 6     | Dil sürümü                   |
| JSON        | Veri formatı (yds_words.json)|

---

## Lisans

Bu proje eğitim amaçlı geliştirilmiştir.
