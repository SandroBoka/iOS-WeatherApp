import SwiftUI

struct WeatherWidgetView: View {

    var title: String

    var body: some View {
        Text(title)
            .font(Font.custom("Noto Sans Mono", size: 16))
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 150, maxHeight: .infinity)
            .background(Color.darkGray)
        .cornerRadius(15)
    }
    
}

extension Color {

    static let darkGray = Color(red: 25/255, green: 25/255, blue: 25/255)

}