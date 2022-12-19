import Assets
import SwiftUI

struct MarvelFavoriteListView: View {
    @ObservedObject private var viewModel: MarvelFavoriteListViewModel
    @Environment(\.editMode) var editMode

    init(viewModel: MarvelFavoriteListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 8)
            Rectangle()
                .fill(Color.black)
                .frame(height: 0.5)
            Spacer()
            if viewModel.favoriteViewModels.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "info.bubble.fill")
                        .foregroundColor(Color(uiColor: .main.accent))
                    Text(Strings.thankYouMessage)
                }
            } else {
                List {
                    ForEach($viewModel.favoriteViewModels) { $viewModel in
                        MarvelFavoriteView(viewModel: viewModel)
                            .listRowSeparator(.hidden)
                    }
                    .onMove { viewModel.orderFavoriteRank(from: $0, to: $1) }
                }
                .listStyle(.plain)
            }
            Spacer()
        }
        .onAppear { viewModel.load() }
        .environment(\.editMode, Binding.constant(EditMode.active))
    }
}
