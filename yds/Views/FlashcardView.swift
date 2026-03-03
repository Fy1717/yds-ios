//
//  FlashcardView.swift
//  yds
//
//  Created by Furkan Yıldız on 18.02.2026.
//

import SwiftUI

struct FlashcardView: View {
    let words: [Word]
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var showTurkish = false
    @State private var direction: CardDirection = .englishToTurkish
    
    enum CardDirection: String, CaseIterable {
        case englishToTurkish = "İngilizce → Türkçe"
        case turkishToEnglish = "Türkçe → İngilizce"
    }
    
    private var progress: Double {
        guard words.count > 0 else { return 0 }
        return Double(currentIndex + 1) / Double(words.count)
    }
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background
                .ignoresSafeArea()
            
            Group {
                if words.isEmpty {
                    emptyState
                } else {
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        progressSection
                        directionPicker
                        cardContent
                        navigationControls
                    }
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.vertical, DesignSystem.Spacing.md)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.Colors.background)
        .navigationTitle("Kartlar")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(DesignSystem.Colors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
#endif
        .tint(DesignSystem.Colors.flashcard)
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.width < -80 && currentIndex < words.count - 1 {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            currentIndex += 1
                            showTurkish = false
                        }
                    } else if value.translation.width > 80 && currentIndex > 0 {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            currentIndex -= 1
                            showTurkish = false
                        }
                    }
                }
        )
    }
    
    private var progressSection: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            HStack {
                Text("\(currentIndex + 1) / \(words.count)")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                Spacer()
            }
            ProgressBar(progress: progress, color: DesignSystem.Colors.flashcard)
        }
    }
    
    private var directionPicker: some View {
        HStack(spacing: 0) {
            ForEach(Array(CardDirection.allCases.enumerated()), id: \.element) { index, d in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        direction = d
                        showTurkish = false
                    }
                } label: {
                    Text(d.rawValue)
                        .font(DesignSystem.Typography.caption)
                        .fontWeight(direction == d ? .semibold : .regular)
                        .foregroundStyle(direction == d ? .white : DesignSystem.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignSystem.Spacing.sm + 2)
                        .background(direction == d ? DesignSystem.Colors.flashcard : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                .stroke(DesignSystem.Colors.flashcard.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var cardContent: some View {
        let word = words[currentIndex]
        
        return VStack(spacing: DesignSystem.Spacing.lg) {
            ZStack {
                RoundedRectangle(cornerRadius: DesignSystem.Radius.xl)
                    .fill(DesignSystem.Colors.cardBackground)
                    .shadow(
                        color: DesignSystem.Shadow.card().color,
                        radius: DesignSystem.Shadow.card().radius,
                        y: DesignSystem.Shadow.card().y
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.Radius.xl)
                            .stroke(DesignSystem.Colors.flashcard.opacity(0.2), lineWidth: 1)
                    )
                
                VStack(spacing: DesignSystem.Spacing.lg) {
                    if direction == .englishToTurkish {
                        Text(word.english)
                            .font(DesignSystem.Typography.title)
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        if showTurkish {
                            revealContent(word: word)
                        }
                    } else {
                        Text(word.turkish)
                            .font(DesignSystem.Typography.title)
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        if showTurkish {
                            revealContent(word: word)
                        }
                    }
                    
                    if !showTurkish {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showTurkish = true
                            }
                        } label: {
                            HStack(spacing: DesignSystem.Spacing.xs) {
                                Image(systemName: "eye.fill")
                                Text("Cevabı Göster")
                            }
                            .font(DesignSystem.Typography.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                            .padding(.vertical, DesignSystem.Spacing.md)
                            .background(Capsule().fill(DesignSystem.Colors.flashcard))
                        }
                        .padding(.top, DesignSystem.Spacing.sm)
                        .buttonStyle(.plain)
                    }
                }
                .padding(DesignSystem.Spacing.xl)
                .frame(maxWidth: .infinity)
            }
            .frame(minHeight: 300)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showTurkish.toggle()
                }
            }
        }
    }
    
    @ViewBuilder
    private func revealContent(word: Word) -> some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Rectangle()
                .fill(DesignSystem.Colors.flashcard.opacity(0.3))
                .frame(height: 2)
                .padding(.horizontal, DesignSystem.Spacing.xl)
            
            Text(direction == .englishToTurkish ? word.turkish : word.english)
                .font(DesignSystem.Typography.title2)
                .foregroundStyle(DesignSystem.Colors.flashcard)
                .multilineTextAlignment(.center)
            
            if let syn = word.synonyms, !syn.isEmpty {
                Text("Eş anlamlı: \(syn)")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.lg)
            }
            
            if !word.example.isEmpty {
                VStack(spacing: DesignSystem.Spacing.sm) {
                    Text(word.example)
                        .font(DesignSystem.Typography.subheadline)
                        .italic()
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    if let exampleTr = word.exampleTurkish, !exampleTr.isEmpty {
                        Text(exampleTr)
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.top, DesignSystem.Spacing.xs)
            }
        }
    }
    
    private var navigationControls: some View {
        HStack(spacing: DesignSystem.Spacing.xl) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    currentIndex = max(0, currentIndex - 1)
                    showTurkish = false
                }
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 44))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(currentIndex > 0 ? DesignSystem.Colors.flashcard : DesignSystem.Colors.textTertiary.opacity(0.5))
            }
            .disabled(currentIndex == 0)
            
            Spacer()
            
            Text("Kaydırarak geç")
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(DesignSystem.Colors.textTertiary)
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    if currentIndex < words.count - 1 {
                        currentIndex += 1
                        showTurkish = false
                    }
                }
            } label: {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 44))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(currentIndex < words.count - 1 ? DesignSystem.Colors.flashcard : DesignSystem.Colors.textTertiary.opacity(0.5))
            }
            .disabled(currentIndex >= words.count - 1)
        }
    }
    
    private var emptyState: some View {
        ContentUnavailableView(
            "Bugün için kelime yok",
            systemImage: "calendar.badge.exclamationmark",
            description: Text("Bu gün için henüz kelime tanımlanmamış. Ana sayfadan farklı bir güne geçebilirsin.")
        )
    }
}

#Preview {
    NavigationStack {
        FlashcardView(words: [
            Word(id: 1, day: 1, english: "necessary", turkish: "gerekli", synonyms: "required, essential", example: "It is necessary to have a visa.", exampleTurkish: "Ülkeye girmek için vize almak gereklidir.")
        ])
    }
}
