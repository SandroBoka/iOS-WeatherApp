import SwiftUI

struct WindWidget: View {

    var model: Model

    @State private var animateRotation = false

    var body: some View {
        VStack {
            Text(model.title.uppercased())
                .font(Font.custom("Noto Sans Mono", size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            animatedWindImage

            Text("\(model.value) km/h")
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

    private var animatedWindImage: some View {
        ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 100, height: 100)

            Text("N")
                .font(Font.custom("Noto Sans Mono", size: 14))
                .foregroundColor(.white)
                .offset(y: -42)

            Circle()
                .foregroundStyle(Color.white).opacity(0.7)
                .frame(width: 70, height: 70)

            Text("----->")
                .font(Font.custom("NDOT45inspiredbyNOTHING", size: 16))
                .rotationEffect(Angle(degrees: model.degree + (animateRotation ? 2 : -2)))
                .foregroundStyle(Color.black)
                .onAppear {
                    withAnimation(
                        Animation
                            .easeInOut(duration: 0.4)
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
        var value: String
        var degree: Double

    }

}

#Preview {
    WindWidget(model: WindWidget.Model(title: "Title", value: "Value", degree: 46))
}
