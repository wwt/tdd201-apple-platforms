//
//  InspectableExtensions.swift
//  WatchLandmarks_FrameworkTests
//
//  Created by thompsty on 4/6/21.
//

import Foundation
import ViewInspector

@testable import WatchLandmarks_Framework

extension Inspection: InspectionEmissary where V: Inspectable { }

extension ContentView: Inspectable { }
extension LandmarkDetail: Inspectable { }

extension CircleImage: Inspectable { }
extension MapView: Inspectable { }
