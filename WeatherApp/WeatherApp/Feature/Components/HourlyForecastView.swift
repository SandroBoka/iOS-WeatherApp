import SwiftUI

struct HourlyForecastView: View {

    let forecast: HourlyForecast

    var body: some View {
        VStack(spacing: 10) {
            Text("\(Int(forecast.temperature))°")
                .font(.dottedFont(size: 20))

            Text("UV: \(Int(forecast.uvIndex))")
                .font(.dottedFont(size: 20))

            Text("\(Int(forecast.percipation * 100))%")
                .font(.dottedFont(size: 20))
        }
        .frame(minHeight: 120)
        .padding()
        .background {
            Color
                .widgetGray
                .cornerRadius(15)
        }
        .cornerRadius(10)
    }

}

#Preview {
    HourlyForecastView(forecast: HourlyForecast(temperature: 24, uvIndex: 3, percipation: 0.3))
}
