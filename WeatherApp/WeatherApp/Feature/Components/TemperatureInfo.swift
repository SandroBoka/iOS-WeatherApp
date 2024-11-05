import SwiftUI

struct TemperatureInfo: View {

    let model: Model

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(model.title.uppercased())
                .font(Font.custom("Noto Sans Mono", size: 14))

            Text(String(format: "%.1f °C", model.temperature))
                .font(Font.custom("NDOT45inspiredbyNOTHING", size: 24))
        }
    }

}

extension TemperatureInfo {

    struct Model {

        let title: String
        let temperature: Double

    }

}
