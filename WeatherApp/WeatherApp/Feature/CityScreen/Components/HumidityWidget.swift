import SwiftUI

struct HumidityWidget: View {

    let model: Model

    @State private var animateHumidity = false

    var body: some View {
        VStack {
            Text(model.title.uppercased())
                .font(.notoSansFont(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            animatedHumidityImage

            Text("\(model.value) %")
                .font(.dottedFont(size: 16))
                .frame(maxHeight: .infinity)
                .padding(.bottom)
        }
        .frame(minHeight: 120)
        .background {
            Color
                .widgetGray
                .cornerRadius(15)
        }
    }

    private var waterLevel: some View {
        Rectangle()
            .frame(height: (Double(model.value)) + (animateHumidity ? 2 : -2))
            .offset(y: 50 - ((Double(model.value))) / 2)
    }

    private var animatedHumidityImage: some View {
        ZStack {
            Circle()
                .stroke(.primaryForeground, lineWidth: 2)
                .frame(width: 100, height: 100)

            Circle()
                .fill(.primaryForeground.opacity(0.7))
                .frame(width: 100, height: 100)
                .mask {
                    waterLevel
                }
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true)
                    ) {
                        animateHumidity.toggle()
                    }
                }
        }
    }

}

extension HumidityWidget {

    struct Model {

        let title: String
        let value: Int

    }

}

#Preview {
    HumidityWidget(model: HumidityWidget.Model(title: "Humidity", value: 45))
}
