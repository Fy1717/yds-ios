//
//  QuizView.swift
//  yds
//
//  Created by Furkan Yıldız on 18.02.2026.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

struct QuizView: View {
    let words: [Word]
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var correctCount = 0
    @State private var questionDirection: QuestionDirection = .englishToTurkish
    @State private var currentOptions: [String] = []
    
    enum QuestionDirection: String, CaseIterable {
        case englishToTurkish = "İngilizce → Türkçe"
        case turkishToEnglish = "Türkçe → İngilizce"
    }
    
    private var currentWord: Word? {
        guard currentIndex < words.count else { return nil }
        return words[currentIndex]
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
                if words.count < 4 {
                    ContentUnavailableView(
                        "Bugün için yeterli kelime yok",
                        systemImage: "questionmark.circle",
                        description: Text("Quiz için en az 4 kelime gerekli. Bu gün için \(words.count) kelime var.")
                    )
                } else if let word = currentWord {
                    ScrollView {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            progressSection
                            questionCard(word: word)
                            optionsGrid
                            if showResult {
                                resultFeedback
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
        .navigationTitle("Quiz")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(DesignSystem.Colors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
#endif
        .tint(DesignSystem.Colors.quiz)
        .onChange(of: currentIndex) { _, _ in
            updateOptions()
        }
        .onChange(of: questionDirection) { _, _ in
            updateOptions()
        }
        .onAppear {
            updateOptions()
        }
        .gesture(
            DragGesture(minimumDistance: 80)
                .onEnded { value in
                    guard showResult else { return }
                    if value.translation.width < -80 && currentIndex < words.count - 1 {
                        goNext()
                    } else if value.translation.width > 80 && currentIndex > 0 {
                        goPrevious()
                    }
                }
        )
    }
    
    private func updateOptions() {
        guard let word = currentWord else { return }
        var opts: [String]
        if questionDirection == .englishToTurkish {
            opts = [word.turkish]
            let others = words.filter { $0.id != word.id }.map(\.turkish)
            opts += others.shuffled().prefix(3)
        } else {
            opts = [word.english]
            let others = words.filter { $0.id != word.id }.map(\.english)
            opts += others.shuffled().prefix(3)
        }
        currentOptions = opts.shuffled()
    }
    
    private func goNext() {
        withAnimation {
            currentIndex += 1
            selectedAnswer = nil
            showResult = false
        }
    }
    
    private func goPrevious() {
        withAnimation {
            currentIndex -= 1
            selectedAnswer = nil
            showResult = false
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            HStack {
                Text("\(currentIndex + 1) / \(words.count)")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                
                Spacer()
                
                Picker("", selection: $questionDirection) {
                    ForEach(QuestionDirection.allCases, id: \.self) { d in
                        Text(d.rawValue).tag(d)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .tint(DesignSystem.Colors.quiz)
            }
            
            ProgressBar(progress: progress, color: DesignSystem.Colors.quiz)
        }
    }
    
    private func questionCard(word: Word) -> some View {
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
                        .stroke(DesignSystem.Colors.quiz.opacity(0.2), lineWidth: 1)
                )
            
            VStack(spacing: DesignSystem.Spacing.md) {
                Text(questionDirection == .englishToTurkish ? word.english : word.turkish)
                    .font(DesignSystem.Typography.title2)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                
                if !word.example.isEmpty {
                    VStack(spacing: DesignSystem.Spacing.xs) {
                        Text(word.example)
                            .font(DesignSystem.Typography.subheadline)
                            .italic()
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                        if let exTr = word.exampleTurkish, !exTr.isEmpty {
                            Text(exTr)
                                .font(DesignSystem.Typography.caption)
                                .foregroundStyle(DesignSystem.Colors.textTertiary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                }
            }
            .padding(DesignSystem.Spacing.lg)
            .frame(maxWidth: .infinity)
        }
    }
    
    private var optionsGrid: some View {
        let correctAnswer = questionDirection == .englishToTurkish ? currentWord?.turkish : currentWord?.english
        
        return VStack(spacing: DesignSystem.Spacing.sm) {
            ForEach(currentOptions, id: \.self) { option in
                Button {
                    guard !showResult else { return }
                    selectedAnswer = option
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showResult = true
                    }
                    if option == correctAnswer {
                        correctCount += 1
                    }
                } label: {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(optionBackground(for: option, correctAnswer: correctAnswer))
                                .frame(width: 32, height: 32)
                            
                            if showResult {
                                if option == correctAnswer {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.white)
                                } else if option == selectedAnswer && option != correctAnswer {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            } else {
                                Text(optionLetter(for: option))
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                            }
                        }
                        
                        Text(option)
                            .font(DesignSystem.Typography.body)
                            .foregroundStyle(optionTextColor(for: option, correctAnswer: correctAnswer))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(DesignSystem.Spacing.md)
                    .background(optionCardBackground(for: option, correctAnswer: correctAnswer))
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.md))
                }
                .disabled(showResult)
                .buttonStyle(.plain)
            }
        }
    }
    
    private func optionLetter(for option: String) -> String {
        guard let index = currentOptions.firstIndex(of: option) else { return "" }
        return String(Unicode.Scalar(65 + index)!)
    }
    
    private func optionBackground(for option: String, correctAnswer: String?) -> Color {
        guard showResult, let correct = correctAnswer else {
            return DesignSystem.Colors.quiz.opacity(0.2)
        }
        if option == correct { return DesignSystem.Colors.success }
        if option == selectedAnswer && option != correct { return DesignSystem.Colors.error }
        return DesignSystem.Colors.quiz.opacity(0.2)
    }
    
    private func optionTextColor(for option: String, correctAnswer: String?) -> Color {
        guard showResult, let correct = correctAnswer else { return DesignSystem.Colors.textPrimary }
        if option == correct { return .white }
        if option == selectedAnswer && option != correct { return .white }
        return DesignSystem.Colors.textPrimary
    }
    
    private func optionCardBackground(for option: String, correctAnswer: String?) -> Color {
        let defaultBg = DesignSystem.Colors.cardBackground
        guard showResult, let correct = correctAnswer else {
            return defaultBg
        }
        if option == correct { return DesignSystem.Colors.success.opacity(0.2) }
        if option == selectedAnswer && option != correct { return DesignSystem.Colors.error.opacity(0.2) }
        return defaultBg
    }
    
    private var resultFeedback: some View {
        let correct = selectedAnswer == (questionDirection == .englishToTurkish ? currentWord?.turkish : currentWord?.english)
        return HStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title2)
                .foregroundStyle(correct ? DesignSystem.Colors.success : DesignSystem.Colors.error)
            Text(correct ? "Doğru!" : "Yanlış!")
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(correct ? DesignSystem.Colors.success : DesignSystem.Colors.error)
        }
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
    
    private var nextButton: some View {
        Button {
            goNext()
        } label: {
            Text(currentIndex < words.count - 1 ? "Sonraki" : "Bitir")
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                        .fill(DesignSystem.Colors.quiz)
                )
        }
        .buttonStyle(.plain)
    }
    
    private var completionView: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.quiz.opacity(0.2))
                    .frame(width: 100, height: 100)
                Image(systemName: "party.popper.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(DesignSystem.Colors.quiz)
            }
            
            Text("Quiz Tamamlandı!")
                .font(DesignSystem.Typography.title)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            
            Text("\(correctCount) / \(words.count) doğru")
                .font(DesignSystem.Typography.title3)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
            
            Button("Başa Dön") {
                withAnimation {
                    currentIndex = 0
                    correctCount = 0
                    selectedAnswer = nil
                    showResult = false
                }
            }
            .buttonStyle(PrimaryButtonStyle(color: DesignSystem.Colors.quiz))
            .frame(maxWidth: 200)
            .padding(.top, DesignSystem.Spacing.md)
        }
        .padding(DesignSystem.Spacing.xl)
    }
}

#Preview {
    NavigationStack {
        QuizView(words: [
            Word(id: 1, day: 1, english: "necessary", turkish: "gerekli", example: "It is necessary."),
            Word(id: 2, day: 1, english: "acquire", turkish: "edinmek", example: "She acquired fluency."),
            Word(id: 3, day: 1, english: "significant", turkish: "önemli", example: "A significant change."),
            Word(id: 4, day: 1, english: "available", turkish: "mevcut", example: "The product is available.")
        ])
    }
}
