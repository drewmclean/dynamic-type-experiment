//
//  FontMetricsGenerator+System.swift
//  FontMetricsGenerator
//
//  Created by Andrew McLean on 10/18/24.
//

import UIKit
import PlayUIKitHelpers

public extension FontMetricsGenerator {
    
    func generateSystemMetrics() {
        let s: String = """
        \(generateSystemFontMetrics())
        
        \(generateTextStyleMetrics())
        """
        print(s)
    }
    
    private func generateSystemFontMetrics() -> String {
        
        var s: String = ""
        s += "static let metricBySize: [Int : FontMetric] = [\n"
        let fontSizeMetricStrings: [String] = (1...200).map { fontSize in
            let font: UIFont = .systemFont(ofSize: CGFloat(fontSize))
            
            let attributedString = NSAttributedString(string: "A", attributes: [NSAttributedString.Key.font: font])

            var kerning: String = ""
            if let kernValue = attributedString.attribute(.kern, at: 0, effectiveRange: nil) as? CGFloat {
                kerning = "\(kernValue)"
            }
            
            return "    \(fontSize): .init(lineHeight: \(font.lineHeight), kerning: \(kerning))"
        }
        s += fontSizeMetricStrings.joined(separator: ",\n")
        s += "\n]\n"
        return s
        
    }
    
    private func generateTextStyleMetrics() -> String {
        var s: String = ""
        
//        s += generateTextStyleMaps(for: UIApplication.shared.preferredContentSizeCategory)
        
        UIContentSizeCategory.allCases.forEach { contentSizeCategory in
            s += generateTextStyleMaps(for: contentSizeCategory)
        }
        
        let contentSizeMapStrings: [String] = UIContentSizeCategory.allCases.map { contentSizeCategory in
            return "    .\(contentSizeCategory.name): \(contentSizeCategory.name)Metrics"
        }
        
        s += "static let metricsByContentSizeCategory: [UIContentSizeCategory : [UIFont.TextStyle : FontMetric]] = [\n"
        s += contentSizeMapStrings.joined(separator: ",\n")
        s += "\n]\n"
        return s
    }
    
    private func generateTextStyleMaps(for contentSizeCategory: UIContentSizeCategory) -> String {
        var s: String = ""
        s += "static let \(contentSizeCategory.name)Metrics: [UIFont.TextStyle : FontMetric] = [\n"
        let textStyleStrings: [String] = UIFont.TextStyle.allCases.map { textStyle in
            let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)
            let font = UIFont.preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
            
            let attributedString = NSAttributedString(string: "A", attributes: [NSAttributedString.Key.font: font])

            var kerning: String = ""
            if let kernValue = attributedString.attribute(.kern, at: 0, effectiveRange: nil) as? CGFloat {
                kerning = "\(kernValue)"
            }
            
            
            return "    \(textStyle.title): .init(lineHeight: \(font.lineHeight), kerning: \(kerning))"
        }
        s += textStyleStrings.joined(separator: ",\n")
        s += "\n]\n\n"
        return s
    }
}
