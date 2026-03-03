//
//  SettingsView.swift
//  yds
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settings = AppSettings.shared
    @State private var reminderTime: Date = .init()
    
    var body: some View {
        List {
            Section {
                Toggle("Dokunsal Geri Bildirim", isOn: $settings.hapticEnabled)
                    .tint(DesignSystem.Colors.primary)
            } header: {
                Text("Deneyim")
            } footer: {
                Text("Kart çevirme, quiz cevabı gibi etkileşimlerde titreşim")
            }
            
            Section {
                Toggle("Günlük Hatırlatma", isOn: $settings.notificationsEnabled)
                    .tint(DesignSystem.Colors.primary)
                    .onChange(of: settings.notificationsEnabled) { _, enabled in
                        if enabled {
                            NotificationManager.shared.requestPermission()
                            NotificationManager.shared.scheduleDailyReminder()
                        } else {
                            NotificationManager.shared.cancelAll()
                        }
                    }
                
                if settings.notificationsEnabled {
                    DatePicker(
                        "Hatırlatma Saati",
                        selection: $reminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: reminderTime) { _, newValue in
                        let comp = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                        settings.notificationHour = comp.hour ?? 9
                        settings.notificationMinute = comp.minute ?? 0
                        NotificationManager.shared.scheduleDailyReminder()
                    }
                }
            } header: {
                Text("Bildirimler")
            } footer: {
                Text("Her gün belirlenen saatte kelime çalışman için hatırlatma")
            }
            
            Section {
                HStack {
                    Text("Sürüm")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(DesignSystem.Colors.background)
        .navigationTitle("Ayarlar")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(DesignSystem.Colors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
#endif
        .tint(DesignSystem.Colors.primary)
        .onAppear {
            reminderTime = settings.notificationTime
            if settings.notificationsEnabled {
                NotificationManager.shared.scheduleDailyReminder()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
