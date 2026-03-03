//
//  HomeView.swift
//  yds
//
//  Created by Furkan Yıldız on 18.02.2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var wordService = WordService()
    @StateObject private var streakService = StreakService.shared
    @StateObject private var favoritesService = FavoritesService.shared
    @State private var showDayPicker = false
    @State private var showAdvanceConfirm = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        headerSection
                        
                        if wordService.isLoading {
                            loadingView
                        } else if let error = wordService.errorMessage {
                            errorView(error)
                        } else {
                            dailyProgressSection
                            learningModesSection
                        }
                    }
                    .padding(DesignSystem.Spacing.md)
                }
                .refreshable {
                    wordService.loadWords()
                }
            }
            .navigationTitle("60 Günde YDS")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(DesignSystem.Colors.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        NavigationLink {
                            StatsView()
                        } label: {
                            Image(systemName: "chart.bar.fill")
                                .foregroundStyle(DesignSystem.Colors.primary)
                        }
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(DesignSystem.Colors.primary)
                        }
                    }
                }
            }
            #endif
            .tint(DesignSystem.Colors.primary)
        }
    }
    
    private var dayPickerSheet: some View {
        NavigationStack {
            List(1...WordService.totalDays, id: \.self) { day in
                Button {
                    wordService.setDay(day)
                    showDayPicker = false
                } label: {
                    HStack {
                        Text("Gün \(day)")
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                        if day == wordService.currentDay {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(DesignSystem.Colors.primary)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(DesignSystem.Colors.background)
            .navigationTitle("Gün Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") {
                        showDayPicker = false
                    }
                    .foregroundStyle(DesignSystem.Colors.primary)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private var headerSection: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            if streakService.streak > 0 {
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("\(streakService.streak) gün streak")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.xs)
                .background(DesignSystem.Colors.cardBackground)
                .clipShape(Capsule())
            }
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                DesignSystem.Colors.primary.opacity(0.2),
                                DesignSystem.Colors.primary.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 88, height: 88)
                
                Image(systemName: "calendar.badge.checkmark")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [DesignSystem.Colors.primary, DesignSystem.Colors.primary.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Text("Her gün belirli kelimelerle pratik yap, sınava hazırlan")
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, DesignSystem.Spacing.lg)
    }
    
    private var dailyProgressSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            HStack {
                Button {
                    showDayPicker = true
                } label: {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Text("Gün \(wordService.currentDay) / \(WordService.totalDays)")
                                .font(DesignSystem.Typography.headline)
                                .foregroundStyle(DesignSystem.Colors.textPrimary)
                            Image(systemName: "chevron.down.circle.fill")
                                .font(.caption)
                                .foregroundStyle(DesignSystem.Colors.primary.opacity(0.6))
                        }
                        Text("\(wordService.todaysWords.count) kelime bugün")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                    }
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                HStack(spacing: DesignSystem.Spacing.sm) {
                    if wordService.currentDay > 1 {
                        Button {
                            wordService.goToPreviousDay()
                        } label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.title2)
                                .foregroundStyle(DesignSystem.Colors.primary.opacity(0.8))
                        }
                    }
                    if wordService.currentDay < WordService.totalDays {
                        Button {
                            showAdvanceConfirm = true
                        } label: {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.title2)
                                .foregroundStyle(DesignSystem.Colors.primary)
                        }
                    }
                }
            }
            .confirmationDialog("Sonraki Güne Geç", isPresented: $showAdvanceConfirm) {
                Button("Gün \(wordService.currentDay + 1)'e Geç") {
                    wordService.advanceToNextDay()
                }
                Button("İptal", role: .cancel) { }
            } message: {
                Text("Bu günün kelimelerini atlayıp sonraki güne geçmek istediğinize emin misiniz?")
            }
            .sheet(isPresented: $showDayPicker) {
                dayPickerSheet
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.lg)
                    .stroke(DesignSystem.Colors.primary.opacity(0.15), lineWidth: 1)
            )
            
            ProgressBar(progress: wordService.progress, color: DesignSystem.Colors.primary)
                .frame(height: 8)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(DesignSystem.Colors.primary)
            Text("Kelimeler yükleniyor...")
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.xxl)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(DesignSystem.Colors.warning)
            Text(message)
                .font(DesignSystem.Typography.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
            Button("Tekrar Dene") {
                wordService.loadWords()
            }
            .buttonStyle(PrimaryButtonStyle(color: DesignSystem.Colors.primary))
            .frame(maxWidth: 200)
        }
        .padding(DesignSystem.Spacing.xl)
    }
    
    private var learningModesSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            LearningModeCard(
                title: "Kartlar",
                subtitle: "Günün kelimeleriyle flashcard çalış",
                icon: "rectangle.stack.fill",
                color: DesignSystem.Colors.flashcard
            ) {
                FlashcardView(words: wordService.shuffledWords())
            }
            
            LearningModeCard(
                title: "Quiz",
                subtitle: "Çoktan seçmeli sorularla test et",
                icon: "checkmark.circle.fill",
                color: DesignSystem.Colors.quiz
            ) {
                QuizView(words: wordService.shuffledWords())
            }
            
            LearningModeCard(
                title: "Çalışma",
                subtitle: "Günün kelimelerini liste halinde incele",
                icon: "list.bullet",
                color: DesignSystem.Colors.study
            ) {
                StudyView(words: wordService.todaysWords)
            }
            
            LearningModeCard(
                title: "Boşluk Doldur",
                subtitle: "Örnek cümledeki eksik kelimeyi bul",
                icon: "pencil.line",
                color: DesignSystem.Colors.fillBlank
            ) {
                FillBlankView(words: wordService.shuffledWords())
            }
            
            if !wordService.wordsUpToCurrentDay.isEmpty {
                let favWords = favoritesService.filterFavorites(from: wordService.wordsUpToCurrentDay)
                if !favWords.isEmpty {
                    LearningModeCard(
                        title: "Favoriler",
                        subtitle: "\(favWords.count) favori kelime ile çalış",
                        icon: "star.fill",
                        color: .yellow
                    ) {
                        FlashcardView(words: favWords.shuffled())
                    }
                }
            }
        }
    }
}

struct LearningModeCard<Destination: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    @ViewBuilder let destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination()) {
            HStack(spacing: DesignSystem.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.25), color.opacity(0.12)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(color)
                }
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                    Text(subtitle)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.Colors.cardSubtitle)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(color.opacity(0.6))
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.lg)
                    .stroke(color.opacity(0.15), lineWidth: 1)
            )
            .shadow(
                color: DesignSystem.Shadow.card().color,
                radius: DesignSystem.Shadow.card().radius,
                y: DesignSystem.Shadow.card().y
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
}
