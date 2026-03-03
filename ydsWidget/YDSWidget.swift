//
//  YDSWidget.swift
//  ydsWidget
//
//  Widget Extension - Ana ekranda bugünkü kelime sayısını gösterir.
//  Kurulum: Xcode > File > New > Target > Widget Extension
//  Bu dosyayı Widget target'ına ekleyin.
//  Ana uygulama ve Widget'a "App Groups" ekleyin: group.com.fy.yds
//

import WidgetKit
import SwiftUI

struct YDSEntry: TimelineEntry {
    let date: Date
    let currentDay: Int
    let todaysWordCount: Int
}

struct YDSProvider: TimelineProvider {
    func placeholder(in context: Context) -> YDSEntry {
        YDSEntry(date: Date(), currentDay: 1, todaysWordCount: 5)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (YDSEntry) -> Void) {
        let entry = YDSEntry(
            date: Date(),
            currentDay: SharedStorage.getCurrentDay(),
            todaysWordCount: SharedStorage.getTodaysWordCount()
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<YDSEntry>) -> Void) {
        let entry = YDSEntry(
            date: Date(),
            currentDay: SharedStorage.getCurrentDay(),
            todaysWordCount: SharedStorage.getTodaysWordCount()
        )
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct YDSWidgetView: View {
    var entry: YDSProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("60 Günde YDS")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("Gün \(entry.currentDay) / 60")
                .font(.title2)
                .fontWeight(.semibold)
            Text("\(entry.todaysWordCount) kelime bugün")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(for: .widget) {
            Color(red: 0.96, green: 0.95, blue: 0.94)
        }
    }
}

struct YDSWidget: Widget {
    let kind: String = "YDSWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: YDSProvider()) { entry in
            YDSWidgetView(entry: entry)
        }
        .configurationDisplayName("60 Günde YDS")
        .description("Bugünkü kelime sayısını görüntüleyin")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    YDSWidget()
} timeline: {
    YDSEntry(date: Date(), currentDay: 5, todaysWordCount: 6)
}
