import SwiftUI

struct CityListView: View {

    @ObservedObject var viewModel: CityListViewModel

    var body: some View {
        NavigationView {
            List(viewModel.cities) { city in
                Button {
                    viewModel.showDetailsForCity(city: city)
                } label: {
                    HStack {
                        Text(city.name)
                            .font(.headline)
                            .foregroundStyle(.black)

                        Spacer()

                        if let temperature = city.temperature {
                            Text("\(temperature, specifier: "%.1f")°C")
                                .foregroundColor(.gray)
                        } else {
                            ProgressView()
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("City Temperatures")
        }
    }

}

#Preview {
    CityListView(
        viewModel: CityListViewModel(
            router: Router(navigationController: UINavigationController()),
            service: WeatherService()))
}
