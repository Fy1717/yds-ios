# 60 Günde YDS — Yabancı Dil Sınavı Hazırlık Uygulaması

YDS'ye 60 günde hazırlanmak isteyenler için günlük kelime öğrenme ve pratik uygulaması.

## Genel Bakış

Bu uygulama, **gün gün** yapılandırılmış kelime listesiyle 60 günde YDS'ye hazırlanmanızı sağlar. Her gün belirli sayıda kelime (eş anlamlıları, örnek cümle ve Türkçe çevirisiyle) sunulur. Kartlar, quiz, çalışma listesi ve boşluk doldurma ile kelimeleri pekiştirirsiniz.

### Özellikler

- **60 günlük program:** Her gün 5–6 kelime, toplamda 300+ kelime
- **Kartlar (Flashcard):** İngilizce ↔ Türkçe yön seçimi, eş anlamlılar, örnek cümleler, swipe, favori işaretleme
- **Quiz:** Çoktan seçmeli, haptic geri bildirim, **yanlışları tekrar et** butonu
- **Çalışma:** Liste halinde incele, arama, **favori işaretleme** ve filtreleme
- **Boşluk Doldur:** Eksik kelimeyi bul, **eş anlamlı kabul**, **yanlışları tekrar et**
- **Favoriler:** Zor kelimeleri yıldızla işaretle, ana sayfada favorilerle flashcard
- **Streak:** Arka arkaya gün tamamlama sayacı (Quiz/Bosluk Doldur)
- **İstatistikler:** Quiz ve boşluk doldur tamamlama sayıları, doğru cevap toplamı
- **Onboarding:** İlk açılışta 4 ekranlık tanıtım
- **Widget:** Ana ekranda bugünkü gün ve kelime sayısı (bkz. `WIDGET_SETUP.md`)
- **Gün seçici:** 1–60 arası doğrudan güne atlama
- **Gün atlama onayı:** Sonraki güne geçmeden önce onay penceresi
- **Ayarlar:** Haptic, günlük hatırlatma saati
- **Bildirimler:** Günlük kelime hatırlatması
- **Pull-to-refresh:** Ana sayfada yenileme

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

### Veri Kaynağı

Uygulama kelimeleri **önce API'den**, API başarısız olursa **statik JSON dosyasından** yükler:

1. **API (öncelikli):** `GET https://yds-api-yhmx.onrender.com/api/words`
   - Açılışta ve pull-to-refresh ile deneme
   - 15 saniye timeout; hata veya timeout'ta statik dosyaya geçer

2. **Statik dosya (yedek):** `yds/assets/yds_words.json` → `sample_words.json`
   - API ulaşılamazsa veya yanıt hatalıysa kullanılır

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
- **Gün seçici:** Gün göstergesine tıklayarak 1–60 arası listeden doğrudan gün seçebilirsiniz.
- Önceki/sonraki gün butonları; sonraki güne geçerken **onay penceresi** gösterilir.
- Tüm pratik modları **o günün kelimeleriyle** çalışır.

---

## Teknik Dokümantasyon

### Mimari

Proje **MVVM benzeri** bir yapı kullanır:

- **Models:** Veri modelleri
- **Services:** Veri yükleme ve işleme
- **Views:** SwiftUI arayüz bileşenleri
- **Utils:** Haptic geri bildirim, uygulama ayarları
- **Theme:** Tasarım sistemi (renkler, tipografi, spacing)

### Proje Yapısı

```
yds/
├── yds/
│   ├── assets/
│   │   ├── yds_words.json         # 60 günlük kelime veritabanı
│   │   └── sample_words.json      # Yedek/örnek kelimeler
│   ├── Models/
│   │   └── Word.swift             # Kelime modeli
│   ├── Services/
│   │   ├── WordService.swift      # Kelime servisi
│   │   ├── NotificationManager.swift  # Günlük hatırlatma
│   │   ├── StreakService.swift    # Günlük streak takibi
│   │   ├── StatsService.swift     # İstatistik (quiz, boşluk doldur)
│   │   └── FavoritesService.swift    # Favori kelimeler
│   ├── Utils/
│   │   ├── HapticManager.swift    # Dokunsal geri bildirim
│   │   ├── AppSettings.swift      # Kullanıcı ayarları
│   │   └── SharedStorage.swift    # Widget veri paylaşımı (App Group)
│   ├── Theme/
│   │   └── DesignSystem.swift    # Renkler, tipografi, spacing
│   ├── Views/
│   │   ├── HomeView.swift         # Ana sayfa
│   │   ├── OnboardingView.swift  # İlk açılış tanıtımı
│   │   ├── SettingsView.swift    # Ayarlar
│   │   ├── StatsView.swift       # İstatistik ekranı
│   │   ├── FlashcardView.swift   # Kart modu (favori desteği)
│   │   ├── QuizView.swift        # Quiz (yanlışları tekrar et)
│   │   ├── StudyView.swift       # Çalışma (favori, filtre)
│   │   └── FillBlankView.swift   # Boşluk doldur (yanlışları tekrar)
│   ├── ContentView.swift          # Kök view (onboarding kontrolü)
│   ├── yds.entitlements           # App Group (group.com.fy.yds)
│   └── ydsApp.swift              # Uygulama giriş noktası
├── ydsWidget/                     # Widget Extension (opsiyonel)
│   ├── YDSWidget.swift           # Widget UI
│   └── SharedStorage.swift       # Veri okuma
├── yds.xcodeproj/
├── README.md
└── WIDGET_SETUP.md               # Widget kurulum rehberi
```

---

## Modüller ve Kod Açıklamaları

### 1. `ydsApp.swift`

Uygulamanın giriş noktası. Başlangıçta bildirim izni ister ve günlük hatırlatma planlar (ayarlar açıksa).

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
- `loadWords()` — Önce API'den GET isteğiyle çeker; başarısızsa statik JSON'dan yükler
- `shuffledWords()` — O günün kelimelerinin karıştırılmış listesi
- `advanceToNextDay()` — Sonraki güne geç
- `goToPreviousDay()` — Önceki güne dön
- `setDay(_:)` — Belirli bir güne (1–60) atla

**Yükleme sırası:** API (`/api/words`) → `yds_words.json` → `sample_words.json`

---

### 5. `Views/HomeView.swift`

Ana sayfa. `WordService` ile kelimeleri yükler, günlük ilerlemeyi gösterir ve dört öğrenme moduna geçiş sağlar.

**Bileşenler:**
- `headerSection` — Başlık ve ikon
- `dailyProgressSection` — Gün göstergesi (tıklanabilir → gün seçici sheet), ilerleme çubuğu, önceki/sonraki gün (onay dialog ile)
- `dayPickerSheet` — 1–60 arası gün listesi
- `learningModesSection` — Mod kartları; favori varsa **Favoriler** kartı
- İstatistik (grafik ikonu) ve ayarlar (dişli ikonu), **pull-to-refresh**

**Modlar:** Kartlar, Quiz, Çalışma, Boşluk Doldur, Favoriler (koşullu)

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
- `cardContent` — Kart (kelime, cevap, eş anlamlılar, örnek cümle, **favori yıldızı**)
- `navigationControls` — Önceki / Sonraki butonları, swipe desteği

---

### 7. `Views/QuizView.swift`

Çoktan seçmeli quiz. Her soruda 4 seçenek sunar; 1 doğru, 3 yanlış.

**Mantık:**
- `currentWord` — Görüntülenen kelime
- `options` — Doğru cevap + diğer kelimelerden 3 yanlış seçenek
- `selectedAnswer` / `showResult` — Kullanıcı cevabı ve sonuç gösterimi
- **Yanlışları tekrar et** — Tamamlandığında yanlış cevaplanan kelimelerle yeni quiz

**Koşul:** En az 4 kelime gerekir (1 doğru + 3 yanlış seçenek için).

---

### 8. `Views/StudyView.swift`

Kelimeleri liste halinde gösterir. Arama ve expand/collapse destekler.

**Özellikler:**
- `searchText` — Arama kutusu
- **Favori işaretleme** — Yıldız ile kelime favorilere eklenir/çıkarılır
- **Sadece favoriler** — Toggle ile sadece favori kelimeleri listele
- `filteredWords` — Filtrelenmiş liste (İngilizce/Türkçe eşleşmesi)
- `expandedIds` — Genişletilmiş (örnek cümle gösterilen) kelime ID'leri

---

### 9. `Views/FillBlankView.swift`

Örnek cümlede kelimeyi `_____` ile değiştirir; kullanıcı eksik kelimeyi yazarak tamamlar.

**Mantık:**
- `wordsWithExamples` — Sadece `example` alanı dolu kelimeler
- `sentenceWithBlank(for:)` — Kelimeyi `_____` ile değiştirir
- `isAnswerCorrect()` — Ana kelime veya **eş anlamlıları** kabul eder; büyük/küçük harf ve boşluklara toleranslı
- **Yanlışları tekrar et** — Tamamlandığında yanlış cevaplanan kelimelerle yeni tur

---

### 10. `Views/SettingsView.swift`

Ayarlar ekranı. Dokunsal geri bildirim (aç/kapa), günlük hatırlatma (aç/kapa + saat), sürüm bilgisi.

---

### 11. `Utils/HapticManager.swift`

Dokunsal geri bildirim: `light()`, `medium()`, `success()`, `error()`, `selection()`. `AppSettings.hapticEnabled` ile kontrol edilir.

---

### 12. `Utils/AppSettings.swift`

Kullanıcı ayarları: `hapticEnabled`, `notificationsEnabled`, `notificationHour`, `notificationMinute`, `hasSeenOnboarding`. UserDefaults ile kalıcı.

---

### 13. `Services/NotificationManager.swift`

Günlük kelime hatırlatması. `UserNotifications` ile belirlenen saatte "Bugünkü kelimeler seni bekliyor!" bildirimi (yalnızca iOS).

---

### 14. `Services/StreakService.swift`

Arka arkaya gün tamamlama (streak). Quiz veya Boşluk Doldur tamamlandığında `recordCompletion(day:)` ile gün kaydedilir.

---

### 15. `Services/StatsService.swift`

İstatistik: `recordQuiz(correct:total:)`, `recordFillBlank(correct:total:)`. Quiz/boşluk doldur tamamlama sayıları ve toplam doğru cevap.

---

### 16. `Services/FavoritesService.swift`

Favori kelimeler. `toggle(_:)`, `isFavorite(_:)`, `filterFavorites(from:)`. UserDefaults ile kalıcı.

---

### 17. `Views/OnboardingView.swift`

İlk açılışta 4 ekranlık tanıtım. `AppSettings.hasSeenOnboarding` ile tekrar gösterilmez.

---

### 18. `Views/StatsView.swift`

İstatistik ekranı. Streak, quiz/boşluk doldur tamamlama ve doğru cevap sayıları.

---

### 19. `Utils/SharedStorage.swift`

App Group (`group.com.fy.yds`) üzerinden Widget ile veri paylaşımı. `updateForWidget(currentDay:todaysWordCount:)`.

---

## Teknoloji Stack

| Teknoloji        | Kullanım                              |
|------------------|----------------------------------------|
| SwiftUI          | UI oluşturma                           |
| Combine          | Reaktif state (@Published)             |
| UserDefaults     | Günlük ilerleme, ayarlar, streak, favoriler |
| UserNotifications| Günlük hatırlatma (iOS)               |
| WidgetKit        | Ana ekran widget (opsiyonel)           |
| App Groups       | Widget veri paylaşımı                 |
| Swift 6          | Dil sürümü                             |
| JSON             | Veri formatı (yds_words.json)          |

---

## Lisans

Bu proje eğitim amaçlı geliştirilmiştir.
