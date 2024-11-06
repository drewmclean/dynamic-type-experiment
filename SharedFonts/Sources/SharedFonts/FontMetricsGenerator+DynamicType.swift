//
//  FontMetricsGenerator+DynamicType.swift
//  FontMetricsGenerator
//
//  Created by Andrew McLean on 10/18/24.
//

import UIKit
import PlayUIKitHelpers
import CryptoKit

public extension FontMetricsGenerator {
    //Hash:  7d5c201605c400d29a6dcd4acf9deb627c33846098fb039359f6b7b1ec4dbe66
    //Hash:  7d5c201605c400d29a6dcd4acf9deb627c33846098fb039359f6b7b1ec4dbe66
    
    func generateDynamicTypeMetrics() {
        let metrics: String = generateHashString()
        let metricsHash: String = sha256(metrics)
        
        print(metrics)
        print("")
        print("Hash: ", metricsHash)
        
    }
    
    private func generateMetricsString() -> String {
        var s: String = ""
        
        UIContentSizeCategory.allCases.forEach { contentSizeCategory in
            s += "ContentSizeCategory(\(contentSizeCategory.name)\n"
            UIFont.TextStyle.allCases.forEach { textStyle in
                s += "--TextStyle(\(textStyle.title)\n"
                (17...17).forEach { size in
                    FontLoader.fontNames.forEach { fontName in
                        let font: UIFont = createScaledFont(name: "NYTCheltenhamBook", size: CGFloat(size), textStyle: textStyle, contentSizeCategory: contentSizeCategory)
                        s += "---Font::\(size)(scaledSize: \(font.pointSize), lineHeight: \(font.lineHeight), leading: \(font.leading))\n"
                    }
                }
            }
        }
        
        return s
    }
    
    private func generateHashString() -> String {
        var s: String = ""
        
        UIContentSizeCategory.allCases.forEach { contentSizeCategory in
            UIFont.TextStyle.allCases.forEach { textStyle in
                (17...17).forEach { size in
                    let fontSize: CGFloat = CGFloat(size)
                    let scaledValue: CGFloat = scaledValue(fontSize, textStyle: textStyle, contentSizeCategory: contentSizeCategory)
                    let formattedScaledValue: String = String(format: "%.3f", scaledValue)
                    let scaledValueFactor: CGFloat = scaledValue / fontSize
                    
                    FontLoader.fontNames.forEach { fontName in
                        let font: UIFont = createScaledFont(name: fontName, size: fontSize, textStyle: textStyle, contentSizeCategory: contentSizeCategory)
                        let formattedSize: String = String(format: "%.3f", font.pointSize)
                        let formattedLineHeight: String = String(format: "%.3f", font.lineHeight)
                        let formattedLeading: String = String(format: "%.3f", font.leading)
                        let sizeToLineHeightRatio: CGFloat = font.lineHeight / font.pointSize
                        
                        s += "\(contentSizeCategory.name)\(textStyle.title):\(fontName):\(size) -> "
    //                    s += "(\(formattedSize)-\(formattedScaledValue)::\(scaledValueFactor.formatAsPercent())\n"
                        s += "(size: \(formattedSize), ld: \(formattedLeading), lh: \(formattedLineHeight), lhr: \(sizeToLineHeightRatio.formatAsPercent())\n"
                    }

                }
            }
        }
        
        return s
    }
    
    private func createScaledFont(
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
    
    private func scaledValue(
        _ value: CGFloat,
        textStyle: UIFont.TextStyle,
        contentSizeCategory: UIContentSizeCategory
    ) -> CGFloat {
        let traitCollection: UITraitCollection = .init(preferredContentSizeCategory: contentSizeCategory)
        let metrics: UIFontMetrics = .init(forTextStyle: textStyle)
        let scaledSize: CGFloat = metrics.scaledValue(for: value, compatibleWith: traitCollection)
        return scaledSize
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)

        // Convert to a hex string
        let hashString = hashed.map { String(format: "%02x", $0) }.joined()
        return hashString
    }
    
}

extension CGFloat {
    func formatAsPercent() -> String {
        let percentageValue = self * 100
        return String(format: "%.00f%%", percentageValue)
    }
}

