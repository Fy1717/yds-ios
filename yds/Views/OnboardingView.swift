//
//  OnboardingView.swift
//  yds
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isCompleted: Bool
    @State private var currentPage = 0
    
    private let pages: [(icon: String, title: String, desc: String)] = [
        ("calendar.badge.checkmark", "60 Günde YDS", "Her gün belirli kelimelerle pratik yap, sınava hazırlan."),
        ("rectangle.stack.fill", "Kartlar & Quiz", "Flashcard ile kelime çalış, quiz ile test et."),
        ("star.fill", "Favoriler & İstatistik", "Zor kelimeleri işaretle, ilerlemeni takip et."),
        ("bell.badge.fill", "Hatırlatmalar", "Günlük bildirimlerle çalışmayı unutma.")
    ]
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: DesignSystem.Spacing.xl) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        onboardingPage(icon: pages[i].icon, title: pages[i].title, desc: pages[i].desc)
                            .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        AppSettings.shared.hasSeenOnboarding = true
                        withAnimation { isCompleted = true } // true = onboarding tamamlandı, ana ekrana geç
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Devam" : "Başla")
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignSystem.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                                .fill(DesignSystem.Colors.primary)
                        )
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.bottom, DesignSystem.Spacing.xl)
            }
        }
    }
    
    private func onboardingPage(icon: String, title: String, desc: String) -> some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Spacer()
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.primary.opacity(0.15))
                    .frame(width: 120, height: 120)
                Image(systemName: icon)
                    .font(.system(size: 52))
                    .foregroundStyle(DesignSystem.Colors.primary)
            }
            Text(title)
                .font(DesignSystem.Typography.title)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.center)
            Text(desc)
                .font(DesignSystem.Typography.body)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isCompleted: .constant(false))
}
