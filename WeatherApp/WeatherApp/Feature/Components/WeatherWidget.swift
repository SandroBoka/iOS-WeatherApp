import SwiftUI

struct WeatherWidget: View {

    let model: Model

    var body: some View {
        VStack {
            Text(model.title.uppercased())
                .font(Font.custom("Noto Sans Mono", size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            Text(model.value)
                .font(Font.custom("NDOT45inspiredbyNOTHING", size: 16))
                .foregroundColor(.white)
                .frame(maxHeight: .infinity)
        }
        .frame(minHeight: 120)
        .background {
            Color
                .darkGray
                .cornerRadius(15)
        }
    }

}

extension WeatherWidget {

    struct Model {

        let title: String
        let value: String

    }

}

extension Color {

    static let darkGray = Color(red: 25/255, green: 25/255, blue: 25/255)

}

#Preview {
    WeatherWidget(model: WeatherWidget.Model(title: "Title", value: "Value"))
}
