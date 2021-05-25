//
//  CategoryHome.swift
//  SwiftUIExample
//
//  Created by Zach Frew on 5/21/21.
//

import SwiftUI

struct CategoryHome: View {
    @EnvironmentObject var appModel: AppModel
    @State private var showingProfile = false
    let inspection = Inspection<Self>()

    var body: some View {
        NavigationView {
            List {
                appModel.features.first?.image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                let categories = appModel.categories.sorted { $0.key < $1.key }
                ForEach(Array(categories.enumerated()), id: \.offset) {
                    CategoryRow(name: $0.element.key, items: $0.element.value)
                }
                .listRowInsets(EdgeInsets())
            }
            .padding(1)
            .navigationTitle("Featured")
            .toolbar {
                Button { showingProfile.toggle() }
                    label: {
                        Image(systemName: "person.crop.circle")
                            .accessibilityLabel("User Profile")
                    }
            }
        }
        .gesture(DragGesture().onChanged { (value) in
            if value.startLocation.y > value.location.y {
                showingProfile = true
            }
        })
        .testableSheet(isPresented: $showingProfile) {
            ProfileHost()
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        let appModel = AppModel()
        // swiftlint:disable line_length
        // swiftlint:disable:next force_try
        let landmarks = try! JSONDecoder().decode([Landmark].self, from: Data("""
[
    {
        "name": "Turtle Rock",
        "category": "Rivers",
        "city": "Twentynine Palms",
        "state": "California",
        "id": 1001,
        "isFeatured": true,
        "isFavorite": true,
        "park": "Joshua Tree National Park",
        "coordinates": {
            "longitude": -116.166868,
            "latitude": 34.011286
        },
        "description": "Test Description",
        "imageName": "turtlerock"
    },
    {
        "name": "Silver Salmon Creek",
        "category": "Lakes",
        "city": "Port Alsworth",
        "state": "Alaska",
        "id": 1002,
        "isFeatured": false,
        "isFavorite": false,
        "park": "Lake Clark National Park and Preserve",
        "coordinates": {
            "longitude": -152.665167,
            "latitude": 59.980167
        },
        "description": "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus, cras ante etiam sit conubia elit tempus accumsan libero, mattis per erat habitasse cubilia ligula penatibus curae. Sagittis lorem augue arcu blandit libero molestie non ullamcorper, finibus imperdiet iaculis ad quam per luctus neque, ligula curae mauris parturient diam auctor eleifend laoreet ridiculus, hendrerit adipiscing sociosqu pretium nec velit aliquam. Inceptos egestas maecenas imperdiet eget id donec nisl curae congue, massa tortor vivamus ridiculus integer porta ultrices venenatis aliquet, curabitur et posuere blandit magnis dictum auctor lacinia, eleifend dolor in ornare vulputate ipsum morbi felis. Faucibus cursus malesuada orci ultrices diam nisl taciti torquent, tempor eros suspendisse euismod condimentum dis velit mi tristique, a quis etiam dignissim dictum porttitor lobortis ad fermentum, sapien consectetur dui dolor purus elit pharetra. Interdum mattis sapien ac orci vestibulum vulputate laoreet proin hac, maecenas mollis ridiculus morbi praesent cubilia vitae ligula vel, sem semper volutpat curae mauris justo nisl luctus, non eros primis ultrices nascetur erat varius integer.",
        "imageName": "silversalmoncreek"
    },
    {
        "name": "Chilkoot Trail",
        "category": "Mountains",
        "city": "Skagway",
        "state": "Alaska",
        "id": 1003,
        "isFeatured": false,
        "isFavorite": true,
        "park": "Klondike Gold Rush National Historical Park",
        "coordinates": {
            "longitude": -135.334571,
            "latitude": 59.560551
        },
        "description": "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus, cras ante etiam sit conubia elit tempus accumsan libero, mattis per erat habitasse cubilia ligula penatibus curae. Sagittis lorem augue arcu blandit libero molestie non ullamcorper, finibus imperdiet iaculis ad quam per luctus neque, ligula curae mauris parturient diam auctor eleifend laoreet ridiculus, hendrerit adipiscing sociosqu pretium nec velit aliquam. Inceptos egestas maecenas imperdiet eget id donec nisl curae congue, massa tortor vivamus ridiculus integer porta ultrices venenatis aliquet, curabitur et posuere blandit magnis dictum auctor lacinia, eleifend dolor in ornare vulputate ipsum morbi felis. Faucibus cursus malesuada orci ultrices diam nisl taciti torquent, tempor eros suspendisse euismod condimentum dis velit mi tristique, a quis etiam dignissim dictum porttitor lobortis ad fermentum, sapien consectetur dui dolor purus elit pharetra. Interdum mattis sapien ac orci vestibulum vulputate laoreet proin hac, maecenas mollis ridiculus morbi praesent cubilia vitae ligula vel, sem semper volutpat curae mauris justo nisl luctus, non eros primis ultrices nascetur erat varius integer.",
        "imageName": "chilkoottrail"
    }
]
""".utf8))
        appModel.landmarks = landmarks
        return CategoryHome()
            .environmentObject(appModel)
    }
}
