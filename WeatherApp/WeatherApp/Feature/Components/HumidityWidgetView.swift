import SwiftUI

struct HumidityWidgetView: View {
    var title: String
    var value: String

    @State private var animateHumidity = false

    var body: some View {
        VStack {
            Text(title.uppercased())
                .font(Font.custom("Noto Sans Mono", size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            ZStack {
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 100, height: 100)

                Circle()
                    .fill(Color.white.opacity(0.7))
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

            Text("\(value) %")
                .font(Font.custom("NDOT45inspiredbyNOTHING", size: 16))
                .foregroundColor(.white)
                .frame(maxHeight: .infinity)
                .padding(.bottom)
        }
        .frame(minHeight: 120)
        .background {
            Color
                .darkGray
                .cornerRadius(15)
        }
    }

    private var waterLevel: some View {
        Rectangle()
            .frame(height: (Double(value) ?? 0) / 100 * 100 + (animateHumidity ? 2 : -2))
            .offset(y: 50 - ((Double(value) ?? 0) / 100 * 100) / 2)
    }

}

#Preview {
    HumidityWidgetView(title: "Humidity", value: "45")
}
