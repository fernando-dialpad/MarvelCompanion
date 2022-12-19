import CoreUI
import SwiftUI

struct MarvelFavoriteView: View {
    @ObservedObject private var viewModel: MarvelFavoriteViewModel

    init(viewModel: MarvelFavoriteViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        HStack(spacing: 16) {
            MediaContainerViewRepresentable(viewModel: viewModel.mediaContainerViewModel)
                .frame(width: 70, height: 70)
            Text(viewModel.character.name)
                .font(.title2)
                .fontWeight(.bold)
        }
        .onAppear { viewModel.load() }
    }
}
