//
//  InspectableExtensions.swift
//  SwiftUIExampleTests
//
//  Created by Richard Gist on 4/8/21.
//

import ViewInspector

@testable import SwiftUIExample

extension Inspection: InspectionEmissary where V: Inspectable {}

extension ContentView: Inspectable {}
extension CategoryHome: Inspectable {}
extension LandmarkList: Inspectable {}
extension LandmarkDetail: Inspectable {}
extension LandmarkRow: Inspectable {}

extension MapView: Inspectable {}
extension CircleImage: Inspectable {}
extension FavoriteButton: Inspectable {}
