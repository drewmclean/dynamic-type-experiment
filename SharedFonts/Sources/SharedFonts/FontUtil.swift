//
//  File.swift
//  
//
//  Created by Andrew McLean on 10/18/24.
//

import UIKit

public struct FontUtil {
    
    // UIFontMetrics:
    // https://developer.apple.com/documentation/uikit/uifontmetrics
    //
    // Typography Spec:
    // https://developer.apple.com/design/human-interface-guidelines/typography#iOS-iPadOS-Dynamic-Type-sizes
    public static func createScaledFont(
        name: String,
        size: CGFloat,
        textStyle: UIFont.TextStyle,
        contentSizeCategory: UIContentSizeCategory
    ) -> UIFont {
        let traitCollection: UITraitCollection = .init(preferredContentSizeCategory: contentSizeCategory)
        let metrics: UIFontMetrics = .init(forTextStyle: textStyle)
        let font: UIFont = .init(name: name, size: size)!
        return metrics.scaledFont(for: font, compatibleWith: traitCollection)
    }
    
    public static func createScaledValue(
        _ value: CGFloat,
        textStyle: UIFont.TextStyle,
        contentSizeCategory: UIContentSizeCategory
    ) -> CGFloat {
        let traitCollection: UITraitCollection = .init(preferredContentSizeCategory: contentSizeCategory)
        let metrics: UIFontMetrics = .init(forTextStyle: textStyle)
        let scaledValue: CGFloat = metrics.scaledValue(for: value, compatibleWith: traitCollection)
        return scaledValue
    }
    
}
