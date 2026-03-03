//
//  StudyView.swift
//  yds
//
//  Created by Furkan Yıldız on 18.02.2026.
//

import SwiftUI

struct StudyView: View {
    let words: [Word]
    @State private var searchText = ""
    @State private var expandedIds: Set<Double> = []
    
    private var filteredWords: [Word] {
        if searchText.isEmpty { return words }
        return words.filter {
            $0.english.localizedCaseInsensitiveContains(searchText) ||
            $0.turkish.localizedCaseInsensitiveContains(searchText) ||
            ($0.synonyms?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
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
                        description: Text("Bu gün için henüz kelime tanımlanmamış. Ana sayfadan farklı bir güne geçebilirsin.")
                    )
                } else {
                    List {
                        ForEach(filteredWords) { word in
                            StudyWordRow(
                                word: word,
                                isExpanded: expandedIds.contains(word.id),
                                onTap: { toggleExpand(word.id) }
                            )
                            .listRowInsets(EdgeInsets(top: 4, leading: DesignSystem.Spacing.md, bottom: 4, trailing: DesignSystem.Spacing.md))
                            .listRowSeparatorTint(DesignSystem.Colors.study.opacity(0.2))
                            .listRowBackground(DesignSystem.Colors.cardBackground)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .searchable(text: $searchText, prompt: "Kelime veya çeviri ara...")
                }
            }
        }
        .navigationTitle("Çalışma")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(DesignSystem.Colors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
#endif
        .tint(DesignSystem.Colors.study)
    }
    
    private func toggleExpand(_ id: Double) {
        withAnimation(.easeInOut(duration: 0.25)) {
            if expandedIds.contains(id) {
                expandedIds.remove(id)
            } else {
                expandedIds.insert(id)
            }
        }
    }
}

struct StudyWordRow: View {
    let word: Word
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Button(action: onTap) {
                HStack(alignment: .center, spacing: DesignSystem.Spacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: DesignSystem.Radius.sm)
                            .fill(DesignSystem.Colors.study.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Text(String(word.english.prefix(1)).uppercased())
                            .font(DesignSystem.Typography.headline)
                            .foregroundStyle(DesignSystem.Colors.study)
                    }
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text(word.english)
                            .font(DesignSystem.Typography.headline)
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                        Text(word.turkish)
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(DesignSystem.Colors.study.opacity(0.6))
                }
                .padding(.vertical, DesignSystem.Spacing.xs)
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    if let syn = word.synonyms, !syn.isEmpty {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.caption2)
                                .foregroundStyle(DesignSystem.Colors.study)
                            Text(syn)
                                .font(DesignSystem.Typography.caption)
                                .foregroundStyle(DesignSystem.Colors.study)
                        }
                    }
                    if !word.example.isEmpty {
                    Text(word.example)
                        .font(DesignSystem.Typography.subheadline)
                        .italic()
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        if let exampleTr = word.exampleTurkish, !exampleTr.isEmpty {
                        Text(exampleTr)
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                        }
                    }
                }
                .padding(.leading, 48)
                .padding(.vertical, DesignSystem.Spacing.xs)
            }
        }
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
}

#Preview {
    NavigationStack {
        StudyView(words: [
            Word(id: 1, day: 1, english: "necessary", turkish: "gerekli", synonyms: "required, essential", example: "It is necessary to have a visa.", exampleTurkish: "Ülkeye girmek için vize almak gereklidir."),
            Word(id: 2, day: 1, english: "acquire", turkish: "edinmek", example: "She acquired fluency.")
        ])
    }
}
