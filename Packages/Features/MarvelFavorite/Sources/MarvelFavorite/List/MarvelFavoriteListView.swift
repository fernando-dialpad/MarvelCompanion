import SwiftUI

struct MarvelFavoriteListView: View {
    @ObservedObject private var viewModel: MarvelFavoriteListViewModel

    init(viewModel: MarvelFavoriteListViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        EmptyView()
    }
}
