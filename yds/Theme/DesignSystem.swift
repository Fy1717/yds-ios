//
//  DesignSystem.swift
//  yds
//
//  Created by Furkan Yıldız on 26.02.2026.
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Design System
/// Tutarlı, modern ve öğrenim odaklı UI için tasarım sistemi.
/// Göz yormayan renkler, net tipografi hiyerarşisi, görsel kolaylaştırıcılar.

enum DesignSystem {
    
    // MARK: - Colors
    /// Öğrenim odaklı, sakin ve odak artırıcı renk paleti
    enum Colors {
        /// Ana arka plan - sıcak, göz yormayan krem tonu
        static let background = Color(red: 0.96, green: 0.95, blue: 0.94)
        
        /// Kart arka planı - hafif krem, beyazdan ayrışan
        static let cardBackground = Color(red: 1.0, green: 0.99, blue: 0.98)
        
        /// Koyu metin - her zaman okunabilir
        static let textPrimary = Color(red: 0.15, green: 0.15, blue: 0.2)
        
        /// İkincil metin
        static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.45)
        
        /// Üçüncül metin (Türkçe cümle vb.)
        static let textTertiary = Color(red: 0.5, green: 0.5, blue: 0.55)
        
        /// Kart alt yazısı - daha okunaklı
        static let cardSubtitle = Color(red: 0.35, green: 0.35, blue: 0.42)
        
        /// Giriş alanı arka planı (grup listesi hücre arka planı)
        static var inputBackground: Color {
            #if os(iOS)
            return Color(uiColor: .secondarySystemGroupedBackground)
            #elseif os(macOS)
            return Color(nsColor: .controlBackgroundColor)
            #else
            return Color(red: 0.95, green: 0.95, blue: 0.97)
            #endif
        }
        
        /// Ana vurgu - derin indigo (odak ve güven)
        static let primary = Color(red: 0.35, green: 0.35, blue: 0.75)
        
        /// Başarı (doğru cevap)
        static let success = Color(red: 0.22, green: 0.65, blue: 0.55)
        
        /// Hata (yanlış cevap)
        static let error = Color(red: 0.85, green: 0.35, blue: 0.35)
        
        /// Uyarı
        static let warning = Color(red: 0.95, green: 0.65, blue: 0.15)
        
        /// Mod renkleri - YDS temasına uyumlu, tutarlı palet (mavi-yeşil-mor ailesi)
        static let flashcard = Color(red: 0.30, green: 0.48, blue: 0.88)   // Koyu mavi
        static let quiz = Color(red: 0.22, green: 0.58, blue: 0.52)         // Deniz yeşili
        static let study = Color(red: 0.55, green: 0.45, blue: 0.75)        // Mor (primary ile uyumlu)
        static let fillBlank = Color(red: 0.45, green: 0.38, blue: 0.82)    // İndigo-mor
        static let conversation = Color(red: 0.20, green: 0.55, blue: 0.62) // Teal
        static let writing = Color(red: 0.48, green: 0.40, blue: 0.72)      // Lavanta
    }
    
    // MARK: - Typography
    /// Okunabilir, modern tipografi ölçeği (SF Pro Rounded - yumuşak, dostça)
    enum Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .rounded)
        static let callout = Font.system(size: 16, weight: .regular, design: .rounded)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .rounded)
        static let footnote = Font.system(size: 13, weight: .regular, design: .rounded)
        static let caption = Font.system(size: 12, weight: .medium, design: .rounded)
    }
    
    // MARK: - Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let pill: CGFloat = 100
    }
    
    // MARK: - Shadows
    enum Shadow {
        static func card() -> (color: Color, radius: CGFloat, y: CGFloat) {
            (Color.black.opacity(0.06), 16, 6)
        }
        static func cardHover() -> (color: Color, radius: CGFloat, y: CGFloat) {
            (Color.black.opacity(0.1), 24, 10)
        }
    }
}

// MARK: - View Modifiers
struct CardStyle: ViewModifier {
    var color: Color = DesignSystem.Colors.primary
    
    func body(content: Content) -> some View {
        content
            .padding(DesignSystem.Spacing.lg)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl))
            .shadow(
                color: DesignSystem.Shadow.card().color,
                radius: DesignSystem.Shadow.card().radius,
                y: DesignSystem.Shadow.card().y
            )
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var color: Color = DesignSystem.Colors.primary
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignSystem.Typography.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                    .fill(color)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct ModeCardStyle: ViewModifier {
    var accentColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.lg)
                    .stroke(accentColor.opacity(0.2), lineWidth: 1)
            )
            .shadow(
                color: DesignSystem.Shadow.card().color,
                radius: DesignSystem.Shadow.card().radius,
                y: DesignSystem.Shadow.card().y
            )
    }
}

// MARK: - Progress Indicator
struct ProgressBar: View {
    let progress: Double
    var color: Color = DesignSystem.Colors.primary
    var height: CGFloat = 6
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color.opacity(0.2))
                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: geo.size.width * min(max(progress, 0), 1), height: height)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: height)
    }
}
