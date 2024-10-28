import SwiftUI

struct NavBar: View {

    let font: Font = Font.custom("NDOT45inspiredbyNOTHING", size: 25)

    var backAction: () -> Void

    var body: some View {
        HStack {
            Button(action: backAction) {
                Text("<")
                    .font(Font.custom("NDOT45inspiredbyNOTHING", size: 28))
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.horizontal)
    }

}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {

    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

}
