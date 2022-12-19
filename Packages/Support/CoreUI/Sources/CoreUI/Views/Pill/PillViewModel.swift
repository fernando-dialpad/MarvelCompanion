import Assets
import Combine
import UIKit

public final class PillViewModel {
    public let backgroundColor: CurrentValueSubject<UIColor, Never>
    public let foregroundColor: CurrentValueSubject<UIColor, Never>
    public let font: CurrentValueSubject<UIFont, Never>
    public let cornerRadius: CurrentValueSubject<Double, Never>
    public let text: CurrentValueSubject<String, Never>

    public init(
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        font: UIFont,
        cornerRadius: Double,
        text: String
    ) {
        self.backgroundColor = .init(backgroundColor)
        self.foregroundColor = .init(foregroundColor)
        self.font = .init(font)
        self.cornerRadius = .init(cornerRadius)
        self.text = .init(text)
    }
}
