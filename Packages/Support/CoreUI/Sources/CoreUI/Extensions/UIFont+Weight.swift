//
//  File.swift
//  
//
//  Created by Fernando del Rio on 17/12/22.
//

import UIKit

public extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }

    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
          return self
        }
        return UIFont(descriptor: descriptor, size: 0)
      }
}
