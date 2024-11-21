import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()

        var entries: [SimpleEntry] = []

        for hoursOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hoursOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

}

struct SimpleEntry: TimelineEntry {

    let date: Date

}

struct WeatherWidgetEntryView: View {

    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack(spacing: 10) {
            Text("Zagreb")
                .font(.notoSansFontWidget(size: 20))

            Text("7.6°C")
                .font(.dottedFontWidget(size: 20))

            if widgetFamily == .systemLarge {

                Text("Humidity: 80%")
                    .font(.dottedFontWidget(size: 15))
                    .padding(.top)

                Image(.sunny)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
            }

            Text("Light Rain")
                .font(.dottedFontWidget(size: 15))
        }
        .containerBackground(.gray.gradient.opacity(0.8), for: .widget)
    }
}

@main
struct WeatherWidget: Widget {

    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Forecast Widget")
        .description("Widget that displays Weather Forecast with Style.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }

}

struct WeatherWidget_Previews: PreviewProvider {

    static var previews: some View {
        WeatherWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }

}

extension Font {

    static func dottedFontWidget(size: Double) -> Font {
        Font.custom("NDOT45inspiredbyNOTHING", size: size)
    }

    static func notoSansFontWidget(size: Double) -> Font {
        Font.custom("Noto Sans Mono", size: size)
    }

}
