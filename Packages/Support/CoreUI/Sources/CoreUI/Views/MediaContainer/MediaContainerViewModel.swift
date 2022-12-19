import Combine
import Core
import Foundation
import Network

public final class MediaContainerViewModel {
    let isRound: Bool
    let borderWidth: Double
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var isLoaded = false
    var imageData = CurrentValueSubject<Data?, Never>(nil)
    @Dependency private var imageService: ImageService

    public init(isRound: Bool, borderWidth: Double) {
        self.isRound = isRound
        self.borderWidth = borderWidth
    }

    public func load(url: URL) {
        Task { @MainActor [weak self] in
            guard !isLoaded else { return }
            isLoading.send(true)
            try await self?.imageData.send(imageService.fetchImage(url: url))
            isLoading.send(false)
            isLoaded = true
        }
    }
}
