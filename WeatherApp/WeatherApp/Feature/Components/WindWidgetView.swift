import SwiftUI

struct WindWidgetView: View {
    var title: String
    var value: String
    var deg: Int

    @State private var animateRotation = false

    var body: some View {
        VStack {
            Text(title.uppercased())
                .font(Font.custom("Noto Sans Mono", size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            ZStack {
                Circle()
                    .stroke(.primaryForeground, lineWidth: 2)
                    .frame(width: 100, height: 100)

                Text("N")
                    .font(Font.custom("Noto Sans Mono", size: 14))
                    .offset(y: -42)

                Circle()
                    .foregroundStyle(.primaryForeground).opacity(0.7)
                    .frame(width: 70, height: 70)

                Text("----->")
                    .font(Font.custom("NDOT45inspiredbyNOTHING", size: 16))
                    .rotationEffect(Angle(degrees: Double(deg) + (animateRotation ? 2 : -2)))
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

            Text("\(value) km/h")
                .font(Font.custom("NDOT45inspiredbyNOTHING", size: 16))
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

}

#Preview {
    WindWidgetView(title: "Wind", value: "14.2", deg: 46)
}
