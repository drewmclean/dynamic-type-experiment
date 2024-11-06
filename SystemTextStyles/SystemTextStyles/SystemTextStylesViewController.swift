//
//  SystemTextStylesViewController.swift
//  SystemTextStyles
//
//  Created by Andrew McLean on 2/28/24.
//

import UIKit
import OSLog

class SystemTextStylesViewController: UIViewController {
    private let log: Logger = .init(subsystem: "", category: "")
    
    private let textWidth: CGFloat = 380
    
    private let textView: UITextView = {
        let textView: UITextView = .init()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .yellow
        textView.isEditable = false
        return textView
    }()
    
    private var textHeight: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeChanged(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
//        logSystemStyles()
//        logSystemFonts()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.widthAnchor.constraint(equalToConstant: textWidth),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
        
        textHeight = textView.heightAnchor.constraint(equalToConstant: 20)
        textHeight?.isActive = true

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        logSystemStyles()
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func updateUI() {
        print("\(traitCollection.preferredContentSizeCategory)")
        textView.attributedText = getAttrString(style: .title1, weight: .regular, width: .standard, design: .default)
        let height = textView.sizeThatFits(.init(width: textWidth, height: 500)).height
        textHeight?.constant = height
        view.layoutIfNeeded()
    }
    
    private func getAttrString(
        isItalic: Bool = false,
        style: UIFont.TextStyle,
        weight: UIFont.Weight,
        width: UIFont.Width,
        design: UIFontDescriptor.SystemDesign
    ) -> NSAttributedString {
        
        let dynamicFont = getFont(style: style, weight: weight, width: width, design: design)
        let sizeCategory: UIContentSizeCategory = traitCollection.preferredContentSizeCategory
        let defaultLineHeight = dynamicFont.lineHeight
        let paragraphStyle = NSMutableParagraphStyle()
        let lineSpacing: CGFloat = 0

        // Convert line spacing to line height multiple
//        paragraphStyle.lineHeightMultiple = convertLineSpacingToLineHeightMultiple(lineSpacing: lineSpacing, defaultLineHeight: defaultLineHeight)

        // Apply paragraph style to an attributed string
        let attributes: [NSAttributedString.Key: Any] = [
            .font: dynamicFont,
            .backgroundColor: UIColor.red,
            .paragraphStyle: paragraphStyle
        ]
//        // Convert back from line height multiple to line spacing
//        let newLineSpacing = convertLineHeightMultipleToLineSpacing(lineHeightMultiple: paragraphStyle.lineHeightMultiple, defaultLineHeight: defaultLineHeight)
        
        let text: String = """
        Info: \(style.title) \(sizeCategory)
        The quick brown fox jumped over the fence over and over. The quick brown fox jumped over the fence over and over. The quick brown fox jumped over the fence over and over. The quick brown fox jumped over the fence over and over. The quick brown fox jumped over the fence over and over. The quick brown fox jumped over the fence over and over. The quick brown fox jumped over the fence over and over. The quick brown fox jumped over the fence over and over. The quick brown fox jumped over the fence over and over. The quick brown fox jumped over the fence over and over.
        """
        
        
        printFont(font: dynamicFont)
        printFont(paragraphStyle: paragraphStyle)
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)

        return attributedString
        
    }
    
    func convertLineSpacingToLineHeightMultiple(lineSpacing: CGFloat, defaultLineHeight: CGFloat) -> CGFloat {
        return (defaultLineHeight + lineSpacing) / defaultLineHeight
    }

    func convertLineHeightMultipleToLineSpacing(lineHeightMultiple: CGFloat, defaultLineHeight: CGFloat) -> CGFloat {
        return (lineHeightMultiple * defaultLineHeight) - defaultLineHeight
    }

    
    private func getFont(isItalic: Bool = false, style: UIFont.TextStyle, weight: UIFont.Weight, width: UIFont.Width, design: UIFontDescriptor.SystemDesign) -> UIFont {
        let preferredFont: UIFont = .preferredFont(forTextStyle: style)
//        let sourceFont: UIFont
//        if isItalic {
//            sourceFont = .italicSystemFont(ofSize: preferredFont.pointSize)
//        } else {
//            sourceFont = preferredFont
//        }
        
        // Use UIFontMetrics to get a dynamic font size based on the text style
//        var descriptor = UIFontMetrics(forTextStyle: style).scaledFont(for: sourceFont).fontDescriptor
        
        //        descriptor = descriptor.addingAttributes([
        //            UIFontDescriptor.AttributeName.traits: [
        //                UIFontDescriptor.TraitKey.weight: weight.rawValue,
        //                UIFontDescriptor.TraitKey.width: width.rawValue
        //            ]
        //        ])
        
//        descriptor = descriptor.withDesign(design)!
        
//        let dynamicFont = UIFont(descriptor: descriptor, size: preferredFont.pointSize)
        return preferredFont
    }
    
    @objc func preferredContentSizeChanged(_ notification: Notification) {
        
        logSystemStyles()
    }
    
    func printFont(font: UIFont) {
//        print("     fontName: \(font.fontName)")
//        print("     familyName: \(font.familyName)")
        print("     pointSize: \(font.pointSize)")
        print("     lineHeight: \(font.lineHeight)")
        print("     ascender: \(font.ascender)")
        print("     descender: \(font.descender)")
        print("     capHeight: \(font.capHeight)")
        print("     fontDescriptor.attributes: ")
        
        font.fontDescriptor.fontAttributes.forEach { key, value in
            print("         \(key) => \(value))")
        }
        print("")
    }
    
    func printFont(paragraphStyle: NSParagraphStyle) {
        print("     lineHeightMultiple: \(paragraphStyle.lineHeightMultiple)")
        print("     lineSpacing: \(paragraphStyle.lineSpacing)")
    }
    
    public func logSystemStyles() {
        log.debug("---------------------------------------")
        log.debug("---------------------------------------")
        log.debug("---------------------------------------")
        log.debug("Contennt Size Category: \(UIApplication.shared.preferredContentSizeCategory.rawValue)")
        
        UIFont.TextStyle.allCases.forEach { textStyle in
            let font: UIFont = .preferredFont(forTextStyle: textStyle)
            
            log.debug("\(textStyle.title, align: .left(columns: 12)) pointSize: \(font.pointSize, format: .fixed(precision: 0), align: .left(columns: 2))  lineHeight: \(font.lineHeight, align: .left(columns: 9))  leading: \(font.leading, align: .left(columns: 14))")
            
            if let weightTrait = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any],
               let weightValue = weightTrait[.weight] as? CGFloat {
                
                let systemFont: UIFont = .systemFont(ofSize: font.pointSize, weight: .init(weightValue))
                log.debug("\("System", align: .left(columns: 12)) pointSize: \(systemFont.pointSize, format: .fixed(precision: 0), align: .left(columns: 2))  lineHeight: \(systemFont.lineHeight, align: .left(columns: 9))  leading: \(systemFont.leading, align: .left(columns: 14))")
            }

            log.debug("---------------------------------------")
        }
//        for i in 1...50 {
//            let size: CGFloat = CGFloat(i)
//            let systemFont: UIFont = .systemFont(ofSize: size)
//            log.debug("\("System", align: .left(columns: 12)) pointSize: \(systemFont.pointSize, format: .fixed(precision: 0), align: .left(columns: 2))  lineHeight: \(systemFont.lineHeight, align: .left(columns: 9))  leading: \(systemFont.leading, align: .left(columns: 14))")
//            printFont(font: systemFont)
//        }
    }
}
