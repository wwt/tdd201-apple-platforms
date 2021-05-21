//
//  MapView.swift
//  SwiftUIExample
//
//  Created by david.roff on 5/20/21.
//

import CoreLocation
import MapKit
import SwiftUI

struct MapView: View {
    @State private var region = MKCoordinateRegion()
    var coordinate: CLLocationCoordinate2D

    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 38.63, longitude: -90.20))
    }
}
