import SwiftUI

struct SunsetWidgetView: View {

    var title: String
    var value: String

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 0) {
            Text(title.uppercased())
                .font(Font.custom("Noto Sans Mono", size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            ZStack {
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    .frame(width: 110, height: isAnimating ? 110 : 100)
                    .offset(y: 10)
                    .rotationEffect(Angle(degrees: 180))

                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.white, lineWidth: 1)
                    .frame(width: 80, height: isAnimating ? 70 : 75)
                    .offset(y: 5)
                    .rotationEffect(Angle(degrees: 180))
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)

                Text("--->")
                    .font(Font.custom("NDOT45inspiredbyNOTHING", size: 12))
                    .foregroundColor(.white)
                    .offset(x: -18)
                    .rotationEffect(Angle(degrees: 90))
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)

                Rectangle()
                    .fill(Color.white.opacity(0.8))
                    .frame(height: 1)
                    .padding(.horizontal, 20)

                VStack(spacing: 5) {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 100, height: 1)
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 70, height: 1)
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 40, height: 1)
                }
                .offset(y: 15)
            }
            .padding(.top)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isAnimating = true
                }
            }

                Text(value)
                    .font(Font.custom("NDOT45inspiredbyNOTHING", size: 16))
                    .foregroundColor(.white)
                    .frame(maxHeight: .infinity)
                    .padding(.bottom)
            }
            .frame(minHeight: 150)
            .background {
                Color.darkGray
                    .cornerRadius(15)
            }
        }

    }

    #Preview {
        SunsetWidgetView(title: "Sunset", value: "17:45")
    }
