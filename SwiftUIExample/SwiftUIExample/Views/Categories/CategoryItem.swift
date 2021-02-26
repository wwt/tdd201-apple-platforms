/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a single category item.
*/
import Foundation
import SwiftUI

struct CategoryItem: View {
    var landmark: Landmark

    var body: some View {
        VStack(alignment: .leading) {
                    landmark.image
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 155, height: 155)
                        .cornerRadius(5)
                    Text(landmark.name)
                        .foregroundColor(.primary)
                        .font(.caption)
                }
                .padding(.leading, 15)
    }
}
