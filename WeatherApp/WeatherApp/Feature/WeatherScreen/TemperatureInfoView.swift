import SwiftUI

struct TemperatureInfoView: View {
    let title: String
    let temperature: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(Font.custom("Noto Sans Mono", size: 14))

            Text("\(String(format: "%.1f", temperature)) °C")
                .font(Font.custom("NDOT45inspiredbyNOTHING", size: 24))
        }
    }
}
