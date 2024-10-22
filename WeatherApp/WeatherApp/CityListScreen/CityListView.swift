import SwiftUI

struct CityListView: View {

    @ObservedObject var viewModel: CityListViewModel

    var body: some View {
        NavigationView {
            List(viewModel.cities) { city in
                HStack {
                    Text(city.name)
                        .font(.headline)

                    Spacer()

                    if let temperature = city.temperature {
                        Text("\(temperature, specifier: "%.1f")°C")
                            .foregroundColor(.gray)
                    } else {
                        ProgressView()
                    }
                }
                .onTapGesture {
                    viewModel.showDetailsForCity(city: city)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("City Temperatures")
        }
    }

}

#Preview {
    CityListView(viewModel: CityListViewModel(router: Router(navigationController: UINavigationController())))
}
