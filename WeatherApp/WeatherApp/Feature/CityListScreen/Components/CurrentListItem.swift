import SwiftUI
import WeatherFramework

struct CurrentListItem: View {

    let city: City
    let action: (City) -> Void

    init(city: City, action: @escaping (City) -> Void) {
        self.city = city
        self.action = action
    }

    var body: some View {
        Button {
            action(city)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("My Location".uppercased())
                        .font(.notoSansFont(size: 10))

                    Text(city.name.uppercased())
                        .font(.notoSansFont(size: 15))
                }

                Spacer()

                if let temperature = city.temperature {
                    Text("\(temperature, specifier: "%.1f")°C")
                        .font(.dottedFont(size: 20))
                } else {
                    ProgressView()
                }
            }
        }
    }

}
