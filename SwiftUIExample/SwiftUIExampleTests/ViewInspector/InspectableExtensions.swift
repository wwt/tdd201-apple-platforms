//
//  InspectableExtensions.swift
//  SwiftUIExampleTests
//
//  Created by david.roff on 5/20/21.
//

import Foundation
import SwiftUI
import ViewInspector
@testable import SwiftUIExample

extension LandmarkDetail: Inspectable { }
extension MapView: Inspectable { }
extension CircleImage: Inspectable { }
extension FavoriteButton: Inspectable { }
extension LandmarkList: Inspectable { }
extension LandmarkRow: Inspectable { }

extension Inspection: InspectionEmissary where V: Inspectable { }
