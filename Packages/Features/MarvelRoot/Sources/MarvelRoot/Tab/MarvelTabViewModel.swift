import Combine
import Core
import DataManager
import SharedModels

final class MarvelTabViewModel {
    let characterNotified = PassthroughSubject<MarvelCharacter, Never>()
    let headerViewModel = MarvelHeaderViewModel()
    @Dependency private var dataListener: MarvelDataListener

    init() {
        getNotifications()
    }

    func load() {
        selectTab(.characters)
    }

    func selectTab(_ tab: MarvelTab) {
        headerViewModel.title.send(tab.title)
    }

    func getNotifications() {
        Task { @MainActor in
            for await character in dataListener.characterNotification {
                characterNotified.send(character)
            }
        }
    }
}
