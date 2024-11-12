import SwiftUI

struct HourlyForecastWidget: View {

    let forecast: HourlyForecast

    var body: some View {
        VStack {
            Text(forecast.formattedHour)
                .font(.dottedFont(size: 18))

            VStack(spacing: 10) {
                Text("\(String(format: "%.1f", forecast.temperature)) \(String(localized: "degree"))")
                    .font(.dottedFont(size: 20))

                Text("\(String(localized: "uvIndex"))\(Int(forecast.uvIndex))")
                    .font(.dottedFont(size: 20))

                Text("\(String(localized: "rain"))\(Int(forecast.percipation * 100))%")
                    .font(.dottedFont(size: 20))
            }
            .frame(minHeight: 120)
            .padding(25)
            .background {
                Color
                    .widgetGray
                    .cornerRadius(15)
            }
            .cornerRadius(10)
        }
    }

}

#Preview {
    HourlyForecastWidget(forecast: HourlyForecast(temperature: 24, uvIndex: 3, percipation: 0.33, hour: 1684929490))
}
