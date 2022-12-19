import SharedModels

final class MarvelTabViewModel {
    let headerViewModel = MarvelHeaderViewModel()

    func load() {
        selectTab(.characters)
    }

    func selectTab(_ tab: MarvelTab) {
        headerViewModel.title.send(tab.title)
    }
}
