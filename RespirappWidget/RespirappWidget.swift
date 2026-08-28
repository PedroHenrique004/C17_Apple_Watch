//
//  RespirappWidget.swift
//  RespirappWidget
//
//  Created by Pedro Santos on 26/08/26.
//

import WidgetKit
import SwiftUI

private let AppGroupID = "group.dev.pedrosantos.respirapp-c17"

struct SimpleEntry: TimelineEntry {
    let date: Date
    let state: String
    let bpm: Int
    let quote: String
    let theme: AppTheme
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), state: "Relaxado", bpm: 68, quote: "Você está se saindo bem!", theme: .purple)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(fetchCurrentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = fetchCurrentEntry()
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    private func fetchCurrentEntry() -> SimpleEntry {
        let sharedDefaults = UserDefaults(suiteName: AppGroupID)
        
        let state = sharedDefaults?.string(forKey: "widgetState") ?? "Relaxado"
        let bpm = sharedDefaults?.integer(forKey: "widgetBPM") ?? 68
        let quote = sharedDefaults?.string(forKey: "widgetQuote") ?? "Você está se saindo bem!"
        let themeRaw = sharedDefaults?.string(forKey: "widgetTheme") ?? AppTheme.purple.rawValue
        let theme = AppTheme(rawValue: themeRaw) ?? .purple
        
        let validBPM = bpm > 0 ? bpm : 68
        
        return SimpleEntry(date: Date(), state: state, bpm: validBPM, quote: quote, theme: theme)
    }
}

struct RespirappWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {

            Text(entry.state)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(entry.theme.accent)

            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.caption2)
                    .foregroundColor(.red)
                
                Text("\(entry.bpm) BPM em média")
                    .font(.system(.footnote, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            

            Text(entry.quote)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

@main
struct RespirappWidget: Widget {
    let kind: String = "RespirappWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RespirappWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    AccessoryWidgetBackground()
                }
        }
        .configurationDisplayName("Estado e BPM")
        .description("Exibe seu estado atual de relaxamento e média de batimentos.")
        .supportedFamilies([.accessoryRectangular])
    }
}
