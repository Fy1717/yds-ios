# Widget Kurulumu

Ana ekranda bugünkü kelime sayısını gösteren widget'ı eklemek için:

## 1. App Groups (Ana Uygulama)

1. Xcode'da **yds** target'ını seçin
2. **Signing & Capabilities** sekmesine gidin
3. **+ Capability** → **App Groups** ekleyin
4. `group.com.fy.yds` ekleyin (veya `yds/yds.entitlements` dosyasını kullanın)

Entitlements kullanıyorsanız, target'ın **Build Settings** → **Code Signing Entitlements** = `yds/yds.entitlements`

## 2. Widget Extension Target Ekleme

1. **File** → **New** → **Target**
2. **Widget Extension** seçin → Next
3. Product Name: `ydsWidget`
4. Include Live Activity: kapalı
5. Finish

## 3. Widget Kodunu Değiştirin

Oluşan `ydsWidget` klasöründeki içeriği silin. `ydsWidget/` kökündeki `YDSWidget.swift` ve `SharedStorage.swift` dosyalarını Widget target'ına sürükleyip ekleyin (Copy items if needed).

Veya yeni target'ın **Build Phases** → **Compile Sources** kısmına bu dosyaları ekleyin.

## 4. Widget App Groups

1. **ydsWidget** target'ında **Signing & Capabilities**
2. **+ Capability** → **App Groups**
3. `group.com.fy.yds` ekleyin

## 5. Ana Uygulama Embed

Ana uygulama target'ında **General** → **Frameworks, Libraries, and Embedded Content** bölümünde `ydsWidgetExtension.appex` embed edilmiş olmalı (Xcode otomatik ekler).

---

Widget, ana uygulama çalıştığında `SharedStorage` üzerinden güncel gün ve kelime sayısını alır.
