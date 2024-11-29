import WidgetKit
import SwiftUI
import Weather
import Combine
import Intents

class Provider: IntentTimelineProvider {

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
        getIdUseCase: GetCurrentLocationIdUseCase(locationRepository: LocationRepository(
            realmService: RealmService(),
            locationManager: LocationDataManager())))

    private var cancellables = Set<AnyCancellable>()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            weatherModel: WeatherModel(dummyData: true),
            cityName: "Zagreb",
            currentTemperatureModel: LargeTemperatureInfo.Model(title: String(localized: "current"), temperature: 20),
            feelsLikeTemperatureModel: LargeTemperatureInfo.Model(
                title: String(localized: "feelsLike"),
                temperature: 19))
    }

    func getSnapshot(
        for configuration: CityNameIntent,
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(
            date: Date(),
            weatherModel: WeatherModel(dummyData: true),
            cityName: "Zagreb",
            currentTemperatureModel: LargeTemperatureInfo.Model(title: String(localized: "current"), temperature: 20),
            feelsLikeTemperatureModel: LargeTemperatureInfo.Model(
                title: String(localized: "feelsLike"),
                temperature: 19))

        completion(entry)
    }

    func getTimeline(
        for configuration: CityNameIntent,
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        Publishers.CombineLatest(viewModel.$currentCityName, viewModel.$weather)
            .first()
            .sink { [weak self] currentCityName, weather in
                guard let self else { return }

                let currentDate = Date()
                let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!

                viewModel.cityNameChanger(cityName: configuration.cityName ?? "")

                let weatherModel = weather ?? WeatherModel(dummyData: true)
                let cityName = currentCityName.isEmpty ? "Unknown" : currentCityName

                let entry = SimpleEntry(
                    date: currentDate,
                    weatherModel: weatherModel,
                    cityName: cityName,
                    currentTemperatureModel: self.viewModel.currentTempratureModel,
                    feelsLikeTemperatureModel: self.viewModel.feelsLikeTempratureModel
                )

                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            }
            .store(in: &cancellables)
    }

}

struct SimpleEntry: TimelineEntry {

    let date: Date
    let weatherModel: WeatherModel
    let cityName: String
    let currentTemperatureModel: LargeTemperatureInfo.Model
    let feelsLikeTemperatureModel: LargeTemperatureInfo.Model

}

struct WeatherWidgetEntryView: View {

    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack(spacing: 0) {
            if widgetFamily == .systemLarge {
                largeWidget
            } else if widgetFamily == .systemMedium {
                mediumWidget
            }
            Text(entry.weatherModel.description)
                .font(.dottedFontWidget(size: 15))
        }
        .foregroundStyle(.primaryForeground)
        .containerBackground(.widgetGray.gradient, for: .widget)
    }

    private var largeWidget: some View {
        VStack(spacing: 15) {
            HStack(alignment: .center, spacing: 50) {
                Text(entry.cityName)
                    .font(.notoSansFontWidget(size: 20))

                Image(entry.weatherModel.weatherImage)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
            }

            Divider()

            temperatureInfo

            Divider()

            Text("\(String(localized: "humidity"))\(entry.weatherModel.humidity)%")
                .font(.dottedFontWidget(size: 15))
                .padding(.top)

            Text(String(format: "\(String(localized: "rain"))%.1f%%", entry.weatherModel.hourlyForecast[0].percipation))
                .font(.dottedFontWidget(size: 15))
                .padding(.bottom)
        }
    }

    private var temperatureInfo: some View {
        HStack(spacing: 30) {
            LargeTemperatureInfo(model: entry.currentTemperatureModel)

            LargeTemperatureInfo(model: entry.feelsLikeTemperatureModel)
        }
    }

    private var mediumWidget: some View {
        VStack(spacing: 15) {
            HStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text(entry.cityName)
                        .font(.notoSansFontWidget(size: 20))

                    Text(String(format: "%.1f \(String(localized: "degree"))", entry.weatherModel.temperature))
                        .font(.dottedFontWidget(size: 20))
                }

                Divider()

                Image(entry.weatherModel.weatherImage)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
            }
        }
    }

}

@main
struct WeatherWidget: Widget {

    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CityNameIntent.self, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Forecast Widget")
        .description(.description)
        .supportedFamilies([.systemMedium, .systemLarge])
    }

}

struct WeatherWidget_Previews: PreviewProvider {

    static var previews: some View {
        WeatherWidgetEntryView(
            entry: SimpleEntry(
                date: Date(),
                weatherModel: WeatherModel(dummyData: true),
                cityName: "Zagreb",
                currentTemperatureModel: LargeTemperatureInfo.Model(title: "Current", temperature: 20),
                feelsLikeTemperatureModel: LargeTemperatureInfo.Model(title: "Feels Like", temperature: 19)))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }

}
