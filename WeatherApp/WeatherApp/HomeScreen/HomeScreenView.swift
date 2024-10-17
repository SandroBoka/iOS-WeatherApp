import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        VStack {
            Image(systemName: "cloud.rain")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Weather app")
                .bold()
        }
        .padding()
    }
}

#Preview {
    HomeScreenView()
}
