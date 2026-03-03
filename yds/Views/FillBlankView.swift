//
//  FillBlankView.swift
//  yds
//
//  Created by Furkan Yıldız on 18.02.2026.
//

import SwiftUI

struct FillBlankView: View {
    let words: [Word]
    @State private var currentIndex = 0
    @State private var userAnswer = ""
    @State private var showResult = false
    @State private var correctCount = 0
    @FocusState private var isAnswerFocused: Bool
    
    private var wordsWithExamples: [Word] {
        words.filter { !$0.example.isEmpty }
    }
    
    private var currentWord: Word? {
        guard currentIndex < wordsWithExamples.count else { return nil }
        return wordsWithExamples[currentIndex]
    }
    
    private var progress: Double {
        guard wordsWithExamples.count > 0 else { return 0 }
        return Double(currentIndex + 1) / Double(wordsWithExamples.count)
    }
    
    private func sentenceWithBlank(for word: Word) -> String {
        word.example.replacingOccurrences(of: word.english, with: "_____", options: .caseInsensitive)
    }
    
    private func isAnswerCorrect() -> Bool {
        userAnswer.trimmingCharacters(in: .whitespaces).lowercased() == currentWord?.english.lowercased()
    }
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background
                .ignoresSafeArea()
            
            Group {
                if words.isEmpty {
                    ContentUnavailableView(
                        "Bugün için kelime yok",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text("Bu gün için kelime bulunamadı.")
                    )
                } else if wordsWithExamples.isEmpty {
                    ContentUnavailableView(
                        "Örnek cümle yok",
                        systemImage: "text.badge.plus",
                        description: Text("Bu günün kelimelerinde örnek cümle bulunamadı.")
                    )
                } else if let word = currentWord {
                    ScrollView {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            progressSection
                            sentenceCard(word: word)
                            answerSection(word: word)
                            if showResult {
                                resultSection
                                nextButton
                                    .padding(.top, DesignSystem.Spacing.md)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.vertical, DesignSystem.Spacing.md)
                    }
                    .scrollDismissesKeyboard(.interactively)
                } else {
                    completionView
                }
            }
        }
        .navigationTitle("Boşluk Doldur")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(DesignSystem.Colors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
#endif
        .tint(DesignSystem.Colors.fillBlank)
        .onChange(of: currentIndex) { _, _ in
            isAnswerFocused = true
        }
        .onAppear {
            isAnswerFocused = true
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            HStack {
                Text("\(currentIndex + 1) / \(wordsWithExamples.count)")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                Spacer()
            }
            ProgressBar(progress: progress, color: DesignSystem.Colors.fillBlank)
        }
    }
    
    private func sentenceCard(word: Word) -> some View {
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
                        .stroke(DesignSystem.Colors.fillBlank.opacity(0.2), lineWidth: 1)
                )
            
            VStack(spacing: DesignSystem.Spacing.md) {
                Text(sentenceWithBlank(for: word))
                    .font(DesignSystem.Typography.body)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                if let exTr = word.exampleTurkish, !exTr.isEmpty {
                    Text(exTr)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(DesignSystem.Spacing.lg)
            .frame(maxWidth: .infinity)
        }
    }
    
    private func answerSection(word: Word) -> some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Text("Eksik kelimeyi yazın:")
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
            
            TextField("Kelime", text: $userAnswer)
                .font(DesignSystem.Typography.body)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .padding(DesignSystem.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                        .fill(DesignSystem.Colors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                                .stroke(DesignSystem.Colors.fillBlank.opacity(0.4), lineWidth: 1)
                        )
                )
#if os(iOS)
                .textInputAutocapitalization(.never)
                .focused($isAnswerFocused)
#endif
                .autocorrectionDisabled()
                .disabled(showResult)
                .onSubmit {
                    if !showResult && !userAnswer.isEmpty {
                        withAnimation {
                            showResult = true
                        }
                        if isAnswerCorrect() { correctCount += 1 }
                    }
                }
            
            if !showResult {
                Button {
                    withAnimation {
                        showResult = true
                    }
                    if isAnswerCorrect() { correctCount += 1 }
                } label: {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Kontrol Et")
                    }
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignSystem.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                            .fill(DesignSystem.Colors.fillBlank)
                    )
                }
                .disabled(userAnswer.isEmpty)
                .opacity(userAnswer.isEmpty ? 0.5 : 1)
                .buttonStyle(.plain)
            }
        }
    }
    
    private var resultSection: some View {
        let correct = isAnswerCorrect()
        return VStack(spacing: DesignSystem.Spacing.sm) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(correct ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                Text(correct ? "Doğru!" : "Yanlış!")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(correct ? DesignSystem.Colors.success : DesignSystem.Colors.error)
            }
            
            if !correct, let word = currentWord {
                Text("Doğru cevap: \(word.english)")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
            }
        }
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
    
    private var nextButton: some View {
        Button {
            withAnimation {
                if currentIndex < wordsWithExamples.count - 1 {
                    currentIndex += 1
                    userAnswer = ""
                    showResult = false
                    isAnswerFocused = true
                } else {
                    currentIndex += 1
                }
            }
        } label: {
            Text(currentIndex < wordsWithExamples.count - 1 ? "Sonraki" : "Bitir")
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                        .fill(DesignSystem.Colors.fillBlank)
                )
        }
        .buttonStyle(.plain)
    }
    
    private var completionView: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.fillBlank.opacity(0.2))
                    .frame(width: 100, height: 100)
                Image(systemName: "party.popper.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(DesignSystem.Colors.fillBlank)
            }
            
            Text("Tamamlandı!")
                .font(DesignSystem.Typography.title)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            
            Text("\(correctCount) / \(wordsWithExamples.count) doğru")
                .font(DesignSystem.Typography.title3)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
            
            Button("Başa Dön") {
                withAnimation {
                    currentIndex = 0
                    correctCount = 0
                    userAnswer = ""
                    showResult = false
                    isAnswerFocused = true
                }
            }
            .buttonStyle(PrimaryButtonStyle(color: DesignSystem.Colors.fillBlank))
            .frame(maxWidth: 200)
            .padding(.top, DesignSystem.Spacing.md)
        }
        .padding(DesignSystem.Spacing.xl)
    }
}

#Preview {
    NavigationStack {
        FillBlankView(words: [
            Word(id: 1, day: 1, english: "necessary", turkish: "gerekli", example: "It is necessary to have a visa.", exampleTurkish: "Ülkeye girmek için vize almak gereklidir.")
        ])
    }
}
