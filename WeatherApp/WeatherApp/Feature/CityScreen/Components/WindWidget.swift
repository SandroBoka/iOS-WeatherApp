import SwiftUI

struct WindWidget: View {

    var model: Model

    @State private var animateRotation = false

    var body: some View {
        VStack {
            Text(model.title.uppercased())
                .font(.notoSansFont(size: 14))

                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            animatedWindImage

            Text(String(format: "%.2f km/h", model.value))
                .font(.dottedFont(size: 16))
                .frame(maxHeight: .infinity)
                .padding(.bottom)
        }
        .frame(minHeight: 120)
        .background {
            Color.widgetGray
                .cornerRadius(15)
        }
    }

    private var animatedWindImage: some View {
        ZStack {
            Circle()
                .stroke(.primaryForeground, lineWidth: 2)
                .frame(width: 100, height: 100)

            Text("N")
                .font(.notoSansFont(size: 14))
                .offset(y: -42)

            Circle()
                .foregroundStyle(.primaryForeground).opacity(0.7)
                .frame(width: 70, height: 70)

            Text("----->")
                .font(.dottedFont(size: 16))
                .rotationEffect(Angle(degrees: Double(model.degree) + (animateRotation ? 2 : -2)))
                .foregroundStyle(.primaryBackground)
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 0.4)
                            .repeatForever(autoreverses: true)
                    ) {
                        animateRotation.toggle()
                    }
                }
        }
    }

}

extension WindWidget {

    struct Model {

        var title: String
        var value: Double
        var degree: Double

    }

}

#Preview {
    WindWidget(model: WindWidget.Model(title: "Title", value: 2.4, degree: 46))
}
