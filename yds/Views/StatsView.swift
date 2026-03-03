//
//  StatsView.swift
//  yds
//

import SwiftUI

struct StatsView: View {
    @StateObject private var stats = StatsService.shared
    @StateObject private var streak = StreakService.shared
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                    Text("\(streak.streak) gün streak")
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                }
            } header: {
                Text("Seri")
            }
            
            Section {
                StatRow(icon: "checkmark.circle.fill", title: "Quiz Tamamlanan", value: "\(stats.quizCompletedCount)", color: DesignSystem.Colors.quiz)
                StatRow(icon: "pencil.line", title: "Boşluk Doldur", value: "\(stats.fillBlankCompletedCount)", color: DesignSystem.Colors.fillBlank)
                StatRow(icon: "star.fill", title: "Toplam Doğru (Quiz)", value: "\(stats.totalCorrectQuiz)", color: DesignSystem.Colors.success)
                StatRow(icon: "star.fill", title: "Toplam Doğru (Boşluk)", value: "\(stats.totalCorrectFillBlank)", color: DesignSystem.Colors.success)
            } header: {
                Text("İstatistikler")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(DesignSystem.Colors.background)
        .navigationTitle("İstatistikler")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(DesignSystem.Colors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
#endif
        .tint(DesignSystem.Colors.primary)
    }
}

private struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 28, alignment: .center)
            Text(title)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            Spacer()
            Text(value)
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        StatsView()
    }
}
