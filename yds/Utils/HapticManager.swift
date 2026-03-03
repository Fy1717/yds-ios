//
//  HapticManager.swift
//  yds
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

/// Dokunsal geri bildirim yönetimi
enum HapticManager {
    #if os(iOS)
    private static let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private static let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private static let notificationGenerator = UINotificationFeedbackGenerator()
    private static let selectionGenerator = UISelectionFeedbackGenerator()
    #endif

    /// Hafif titreşim (kart çevirme, sayfa değişimi)
    static func light() {
        #if os(iOS)
        guard AppSettings.shared.hapticEnabled else { return }
        lightGenerator.prepare()
        lightGenerator.impactOccurred()
        #endif
    }

    /// Orta titreşim (buton tıklama)
    static func medium() {
        #if os(iOS)
        guard AppSettings.shared.hapticEnabled else { return }
        mediumGenerator.prepare()
        mediumGenerator.impactOccurred()
        #endif
    }

    /// Doğru cevap
    static func success() {
        #if os(iOS)
        guard AppSettings.shared.hapticEnabled else { return }
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(.success)
        #endif
    }

    /// Yanlış cevap
    static func error() {
        #if os(iOS)
        guard AppSettings.shared.hapticEnabled else { return }
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(.error)
        #endif
    }

    /// Seçim değişikliği (picker vb.)
    static func selection() {
        #if os(iOS)
        guard AppSettings.shared.hapticEnabled else { return }
        selectionGenerator.prepare()
        selectionGenerator.selectionChanged()
        #endif
    }
}
