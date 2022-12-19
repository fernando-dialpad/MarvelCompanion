import SwiftUI

struct MarvelFavoriteView: View {
    @ObservedObject private var viewModel: MarvelFavoriteViewModel

    init(viewModel: MarvelFavoriteViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        EmptyView()
    }
}
