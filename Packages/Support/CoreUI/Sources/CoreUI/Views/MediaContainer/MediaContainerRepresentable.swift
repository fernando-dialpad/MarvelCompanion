import SwiftUI

public struct MediaContainerViewRepresentable: UIViewRepresentable {
    private var viewModel: MediaContainerViewModel

    public init(viewModel: MediaContainerViewModel) {
        self.viewModel = viewModel
    }

    public func makeUIView(context: Context) -> MediaContainerView {
        MediaContainerView(viewModel: viewModel)
    }

    public func updateUIView(_ uiView: MediaContainerView, context: Context) {}
}
