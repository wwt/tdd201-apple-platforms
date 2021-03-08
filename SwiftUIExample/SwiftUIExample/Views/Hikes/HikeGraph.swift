/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 The elevation, heart rate, and pace of a hike plotted on a graph.
 */

import SwiftUI

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
}

struct HikeGraph: View {
    var hike: Hike
    var path: KeyPath<Hike.Observation, Range<Double>>

    var color: Color {
        switch path {
            case \.elevation:
                return .gray
            case \.heartRate:
                return Color(hue: 0, saturation: 0.5, brightness: 0.7)
            case \.pace:
                return Color(hue: 0.7, saturation: 0.4, brightness: 0.7)
            default:
                return .black
        }
    }

    var body: some View {
        let data = hike.observations
        let ranges = data.lazy.map { $0[keyPath: path ]}
        let firstRange = ranges.first ?? 0..<0
        let overallRange = ranges.reduce(into: firstRange) { reducer, range in
            reducer = min(reducer.lowerBound, range.lowerBound)..<max(reducer.upperBound, range.upperBound)
        }

        let maxMagnitude = ranges.map { $0.magnitude }.max(by: <) ?? firstRange.magnitude
        let heightRatio = 1 - CGFloat(maxMagnitude / overallRange.magnitude )

        return GeometryReader { proxy in
            HStack(alignment: .bottom, spacing: proxy.size.width / 120) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, observation in
                    GraphCapsule(
                        index: index,
                        height: proxy.size.height,
                        range: observation[keyPath: path],
                        overallRange: overallRange)
                        .colorMultiply(color)
                        .transition(.slide)
                        .animation(.ripple(index: index))
                }
                .offset(x: 0, y: proxy.size.height * heightRatio)
            }
        }
    }
}

struct HikeGraph_Previews: PreviewProvider {
    static var hike = AppModel().hikes[0]

    static var previews: some View {
        Group {
            HikeGraph(hike: hike, path: \.elevation)
                .frame(height: 200)
            HikeGraph(hike: hike, path: \.heartRate)
                .frame(height: 200)
            HikeGraph(hike: hike, path: \.pace)
                .frame(height: 200)
        }
    }
}
