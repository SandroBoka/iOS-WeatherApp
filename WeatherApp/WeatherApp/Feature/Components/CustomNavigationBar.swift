import SwiftUI

struct NavigationBar: View {

    let font: Font = Font.custom("NDOT45inspiredbyNOTHING", size: 25)

    var backAction: () -> Void

    var body: some View {
        Button(action: backAction) {
            Text("<")
                .font(Font.custom("NDOT45inspiredbyNOTHING", size: 28))
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}
