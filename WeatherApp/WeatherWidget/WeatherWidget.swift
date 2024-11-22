import WidgetKit
import SwiftUI
import Weather

import Combine

class Provider: TimelineProvider {

    private let viewModel = WeatherWidgetViewModel(
        getLocationUseCase: GetCurrentLocationUseCase(
            locationRepository: LocationRepository(
                realmService: RealmService(),
                locationManager: LocationDataManager())),
        getWeatherUseCase: GetCurrentWeatherUseCase(
            weatherRepository: WeatherRepository(
                weatherService: WeatherService(client: NetworkClient()),
                locationService: LocationService(client: NetworkClient()),
                realmService: RealmService())),
        getIdUseCase: GetCurrentLocationId())

    private var cancellables = Set<AnyCancellable>()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), weatherModel: WeatherModel(dummyData: true), cityName: "Zagreb")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), weatherModel: WeatherModel(dummyData: true), cityName: "Zagreb")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        viewModel.fetchWeather()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print("Error fetching weather with Combine: \(error)")
                }
            }, receiveValue: { [weak self] weatherModel in
                guard let self else { return }

                let currentDate = Date()
                let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!

                let cityName = self.viewModel.currentCityName != "" ? self.viewModel.currentCityName: "Unknown"

                let entry = SimpleEntry(
                    date: currentDate,
                    weatherModel: weatherModel,
                    cityName: cityName
                )

                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            })
            .store(in: &cancellables)

        //        Publishers.CombineLatest(viewModel.$currentCityName, viewModel.$weather)
        //            .first()
        //            .sink { currentCityName, weather in
        //                let currentDate = Date()
        //                let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        //
        //                let weatherModel = weather ?? WeatherModel(dummyData: true)
        //                let cityName = currentCityName.isEmpty ? "Unknown" : currentCityName
        //
        //                let entry = SimpleEntry(
        //                    date: currentDate,
        //                    weatherModel: weatherModel,
        //                    cityName: cityName
        //                )
        //
        //                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        //                completion(timeline)
        //            }
        //            .store(in: &cancellables)
    }

}

struct SimpleEntry: TimelineEntry {

    let date: Date
    let weatherModel: WeatherModel
    let cityName: String

}

struct WeatherWidgetEntryView: View {

    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack(spacing: 10) {
            if widgetFamily == .systemLarge {

                Text(entry.cityName)
                    .font(.notoSansFontWidget(size: 20))

                Text(String(format: "%.1f °C", entry.weatherModel.temperature))
                    .font(.dottedFontWidget(size: 20))

                Text("Humidity: \(entry.weatherModel.humidity)%")
                    .font(.dottedFontWidget(size: 15))
                    .padding(.top)

                Image(entry.weatherModel.weatherImage)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
            } else if widgetFamily == .systemMedium {
                HStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Text(entry.cityName)
                            .font(.notoSansFontWidget(size: 20))

                        Text(String(format: "%.1f °C", entry.weatherModel.temperature))
                            .font(.dottedFontWidget(size: 20))
                    }

                    Divider()

                    Image(entry.weatherModel.weatherImage)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                }
            }
            Text(entry.weatherModel.description)
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
        WeatherWidgetEntryView(
            entry: SimpleEntry(date: Date(), weatherModel: WeatherModel(dummyData: true), cityName: "Zagreb"))
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
