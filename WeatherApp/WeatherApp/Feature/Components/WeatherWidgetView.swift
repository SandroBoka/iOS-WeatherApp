import SwiftUI

struct WeatherWidgetView: View {

    var title: String
    var value: String

    var body: some View {
        VStack {
            Text(title.uppercased())
                .font(.notoSansFont(size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            Text(value)
                .font(.dottedFont(size: 16))
                .foregroundColor(.white)
                .frame(maxHeight: .infinity)
        }
        .frame(minHeight: 120)
        .background {
            Color
                .widgetGray
                .cornerRadius(15)
        }
    }

}

#Preview {
    WeatherWidgetView(title: "Title", value: "Value")
}
