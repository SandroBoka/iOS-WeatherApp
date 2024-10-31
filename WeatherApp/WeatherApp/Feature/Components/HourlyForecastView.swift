import SwiftUI

struct HourlyForecastView: View {

    let forecast: HourlyForecast

    var body: some View {
        VStack(spacing: 10) {
            Text("\(String(format: "%.1f", forecast.temperature)) °C")
                .font(.dottedFont(size: 20))

            HStack(spacing: 15) {
                Text("UV :")
                    .font(.notoSansFont(size: 20))

                Text("\(Int(forecast.uvIndex))")
                    .font(.dottedFont(size: 20))
            }

            Text("\(Int(forecast.percipation * 100))%")
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

#Preview {
    HourlyForecastView(forecast: HourlyForecast(temperature: 24, uvIndex: 3, percipation: 0.33, hour: 1684929490))
}
