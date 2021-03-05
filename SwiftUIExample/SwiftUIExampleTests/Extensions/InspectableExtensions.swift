//
//  InspectableExtensions.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/25/21.
//

import Foundation
import ViewInspector

@testable import SwiftUIExample
#warning("Not tested list")
/*
 GeometryReader - Proxy
 DatePicker - selection and date range
 Private @State
 EnvironmentObjects in child views
 */

extension Inspection: InspectionEmissary where V: Inspectable { }

extension ContentView: Inspectable { }
extension CategoryHome: Inspectable { }
extension CategoryRow: Inspectable { }

extension LandmarkList: Inspectable { }
extension LandmarkDetail: Inspectable { }
extension LandmarkRow: Inspectable { }

extension HikeBadge: Inspectable { }
extension GraphCapsule: Inspectable { }
extension HikeGraph: Inspectable { }
extension HikeDetail: Inspectable { }
extension HikeView: Inspectable { }

extension ProfileEditor: Inspectable { }
extension ProfileSummary: Inspectable { }
extension ProfileHost: Inspectable { }

extension Badge: Inspectable { }
extension MapView: Inspectable { }
