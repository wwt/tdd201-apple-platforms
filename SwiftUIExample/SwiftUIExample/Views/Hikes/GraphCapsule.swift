//
//  GraphCapsule.swift
//  SwiftUIExample
//
//  Created by David Roff on 7/7/21.
//

import SwiftUI

struct GraphCapsule: View {
    var index: Int
    var height: CGFloat
    var range: Range<Double>
    var overallRange: Range<Double>

    var heightRatio: CGFloat {
        max(CGFloat(range.magnitude / overallRange.magnitude), 0.15)
    }

    var offsetRatio: CGFloat {
        CGFloat((range.lowerBound - overallRange.lowerBound) / overallRange.magnitude)
    }

    var body: some View {
        Capsule()
            // Offset MUST be first or we can't test it.
            .offset(x: 0, y: height * -offsetRatio)
            .fill(Color.white)
            .frame(height: height * heightRatio)
    }
}

struct GraphCapsule_Previews: PreviewProvider {
    static var previews: some View {
        // The graph that uses the capsule tints it by multiplying against its
        // base color of white. Emulate that behavior here in the preview.
        GraphCapsule(index: 0, height: 150, range: 10..<50, overallRange: 0..<100)
            .colorMultiply(.blue)
    }
}

