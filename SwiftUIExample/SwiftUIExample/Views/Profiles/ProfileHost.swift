/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that hosts the profile viewer and editor.
*/

import SwiftUI
import Combine

struct ProfileHost: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var appModel: AppModel
    @ObservedObject private var viewModel = ViewModel()
    @State var draftProfile = Profile.default
    @State private var hikesResult: Result<[Hike], API.HikesService.Error>? {
        didSet {
            switch hikesResult {
                case .success(let hikes): appModel.hikes = hikes
                default: break
            }
        }
    }
    internal let inspection = Inspection<Self>()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel") {
                        draftProfile = appModel.profile
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }

            if editMode?.wrappedValue == .inactive {
                ProfileSummary(hikes: $appModel.hikes, profile: appModel.profile)
            } else {
                ProfileEditor(profile: $draftProfile)
                    .onAppear {
                        draftProfile = appModel.profile
                    }
                    .onDisappear {
                        appModel.profile = draftProfile
                    }
            }
        }
        .padding()
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
        .onAppear {
            viewModel.hikesService?.fetchHikes.map(Optional.some)
                .assign(to: \.hikesResult, on: self).store(in: &viewModel.subscribers)
        }
    }
}

extension ProfileHost {
    fileprivate final class ViewModel: ObservableObject {
        @DependencyInjected var hikesService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
            .environmentObject(AppModel())
    }
}
