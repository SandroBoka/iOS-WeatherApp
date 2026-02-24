import SwiftUI

struct NavigationBar: View {

    var backAction: () -> Void

    var body: some View {
        Button(action: backAction) {
            Text("<")
                .font(.dottedFont(size: 28))
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}
