import SwiftUI

struct SunriseWidget: View {

    var model: Model

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 0) {
            Text(model.title.uppercased())
                .font(.notoSansFont(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            animatedSunriseImage
                .padding(.top)
                .onAppear {
                    isAnimating = true
                }

            Text(model.value)
                .font(.dottedFont(size: 16))
                .frame(maxHeight: .infinity)
                .padding(.bottom)
        }
        .frame(minHeight: 150)
        .background {
            Color.widgetGray
                .cornerRadius(15)
        }
    }

    private var animatedSunriseImage: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(.primaryForeground.opacity(0.5), lineWidth: 2)
                .frame(width: 110, height: isAnimating ? 110 : 100)
                .offset(y: 10)
                .rotationEffect(Angle(degrees: 180))

            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(.primaryForeground, lineWidth: 1)
                .frame(width: 80, height: isAnimating ? 80 : 85)
                .offset(y: 10)
                .rotationEffect(Angle(degrees: 180))
                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)

            Text("--->")
                .font(.dottedFont(size: 12))
                .offset(x: 21)
                .rotationEffect(Angle(degrees: 270))
                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)

            Rectangle()
                .fill(.primaryForeground.opacity(0.8))
                .frame(height: 1)
                .padding(.horizontal, 20)

            VStack(spacing: 5) {
                Rectangle()
                    .fill(.primaryForeground.opacity(0.3))
                    .frame(width: 100, height: 1)
                Rectangle()
                    .fill(.primaryForeground.opacity(0.2))
                    .frame(width: 70, height: 1)
                Rectangle()
                    .fill(.primaryForeground.opacity(0.1))
                    .frame(width: 40, height: 1)
            }
            .offset(y: 15)
        }
    }

}

extension SunriseWidget {

    struct Model {

        var title: String
        var value: String

    }

}

#Preview {
    SunriseWidget(model: SunriseWidget.Model(title: "Sunrise", value: "07:45"))
}
