import SwiftUI

struct LargeTemperatureInfo: View {

    let model: Model

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(model.title.uppercased())
                .font(.notoSansFontWidget(size: 14))

            Text(String(format: "%.1f °C", model.temperature))
                .font(.dottedFontWidget(size: 24))
        }
    }

}

extension LargeTemperatureInfo {

    struct Model {

        let title: String
        var temperature: Double

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
