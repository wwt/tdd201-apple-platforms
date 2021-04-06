//
//  ContentView.swift
//  WatchLandmarks Extension
//
//  Created by Richard Gist on 4/6/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel
    @ObservedObject private var viewModel = ViewModel()
    @State private var landmarksResult: Result<[Landmark], API.HikesService.Error>? {
        didSet {
            switch landmarksResult {
                case .success(let landmarks): appModel.landmarks = landmarks
                case .failure: showAlert = true
                default: break
            }
        }
    }
    @State private var showAlert = false

    let inspection = Inspection<Self>()

    var body: some View {
        Group {
            switch landmarksResult {
                case .none:
                    ProgressView()
                default:
                    LandmarkList()
            }
        }
        .onAppear {
            viewModel.hikesService?.fetchLandmarks.map(Optional.some).receive(on: DispatchQueue.main)
                .assign(to: \.landmarksResult, on: self).store(in: &viewModel.subscribers)
        }
        .alert(isPresented: $showAlert) {
            let errors: [String] = {
                var allErrors = [String]()
                if case .failure(let err) = landmarksResult,
                   case .apiBorked(let underlyingError) = err { allErrors.append(underlyingError.localizedDescription) }
                return allErrors
            }()
            return Alert(title: Text(errors.joined(separator: "\n")))
        }
        .onReceive(inspection.notice) { inspection.visit(self, $0) }
    }
}

extension ContentView {
    fileprivate final class ViewModel: ObservableObject {
        @DependencyInjected var hikesService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}
