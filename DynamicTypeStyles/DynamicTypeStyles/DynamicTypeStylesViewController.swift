//
//  DynamicTypeStylesViewController.swift
//  DynamicTypeStyles
//
//  Created by Andrew McLean on 10/17/24.
//

import UIKit
import PlayUIKitHelpers
import SharedFonts

class DynamicTypeStylesViewController: UIViewController {
    
    let contentSizeCategoryLabel = UILabel()
    let contentSizeCategorySlider = UISlider()

    let fontLabel = UILabel()
    let fontSlider = UISlider()
    
    let fontSizeLabel = UILabel()
    let fontSizeSlider = UISlider()
    
    let fontStyleLabel = UILabel()
    let fontStyleSlider = UISlider()
    
    let fontInfoLabel = UILabel()
    
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeChanged(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        setupUI()
    }
    
    private func setupUI() {
        
        // Font
        fontLabel.textAlignment = .left
        fontLabel.textColor = .label
        
        fontSlider.translatesAutoresizingMaskIntoConstraints = false
        fontSlider.minimumValue = 0
        fontSlider.maximumValue = Float(FontLoader.fontNames.count-1)
        fontSlider.value = 0
        fontSlider.addTarget(self, action: #selector(fontSliderChanged(_:)), for: .valueChanged)
        
        // Content Size Category
        contentSizeCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentSizeCategoryLabel.textAlignment = .left
        
        contentSizeCategoryLabel.textColor = .label
        contentSizeCategoryLabel.numberOfLines = 0
        contentSizeCategorySlider.translatesAutoresizingMaskIntoConstraints = false
        contentSizeCategorySlider.minimumValue = 0
        contentSizeCategorySlider.maximumValue = Float(UIContentSizeCategory.allCases.count)
        contentSizeCategorySlider.value = 0
        contentSizeCategorySlider.addTarget(self, action: #selector(contentSizeCategorySliderChanged(_:)), for: .valueChanged)
        
        // Font Size
        fontSizeLabel.textAlignment = .left
        fontSizeLabel.textColor = .label
        
        fontSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        fontSizeSlider.minimumValue = 1
        fontSizeSlider.maximumValue = 80
        fontSizeSlider.value = 17
        fontSizeSlider.addTarget(self, action: #selector(fontSizeSliderChanged(_:)), for: .valueChanged)
        
        // Font Style
        fontStyleLabel.translatesAutoresizingMaskIntoConstraints = false
        fontStyleLabel.textAlignment = .left
        fontStyleLabel.textColor = .label
        
        fontStyleSlider.translatesAutoresizingMaskIntoConstraints = false
        fontStyleSlider.minimumValue = 0
        fontStyleSlider.maximumValue = Float(UIFont.TextStyle.allCases.count)
        fontStyleSlider.value = 0
        fontStyleSlider.addTarget(self, action: #selector(fontStyleSliderChanged(_:)), for: .valueChanged)
        
        // Font Info Label
        fontInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        fontInfoLabel.textAlignment = .left
        fontInfoLabel.numberOfLines = 0
        fontInfoLabel.textColor = .label
        
        // TextView setup
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vel pellentesque lectus. Vivamus finibus sem mi, eget pellentesque libero pulvinar tincidunt. Cras hendrerit mollis felis, at tincidunt nunc rutrum a."
        textView.textAlignment = .left
        textView.isEditable = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.secondarySystemFill.cgColor
        textView.layer.cornerRadius = 6
        textView.textColor = .label
        
        // StackView setup
        let stackView = UIStackView(arrangedSubviews: [
            contentSizeCategoryLabel,
            contentSizeCategorySlider,
            fontLabel,
            fontSlider,
            fontSizeLabel,
            fontSizeSlider,
            fontStyleLabel,
            fontStyleSlider,
            fontInfoLabel, // Add the new label to the stack view
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        
        view.addSubview(stackView)
        
        [contentSizeCategorySlider, fontSizeSlider, fontStyleSlider].forEach { view in
            stackView.setCustomSpacing(16, after: view)
        }
        
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        // Initialize the text view's font and the label text
        updateTextViewFont()
    }
    
    // Update textView font and fontInfoLabel whenever sliders change
    private func updateTextViewFont() {
        let postscriptName: String = FontLoader.fontNames[Int(fontSlider.value)]
        
        let fontSize = CGFloat(Int(fontSizeSlider.value))
        
        let sizeCategory: String
        let style: String
        let scaleFactor: String
        let scaledSize: String
        let font: UIFont
        
        let contentSizeCategory: UIContentSizeCategory
        let contentSizeSliderValue = Int(contentSizeCategorySlider.value)
        
        if contentSizeSliderValue == 0 {
            contentSizeCategory = traitCollection.preferredContentSizeCategory
            sizeCategory = "(System) \(contentSizeCategory.name)"
        } else {
            let sizeCategoryIndex: Int = contentSizeSliderValue - 1
            contentSizeCategory = UIContentSizeCategory.allCases[sizeCategoryIndex]
            sizeCategory = "(Override) \(contentSizeCategory.name)"
        }
        
        let styleSliderValue = Int(fontStyleSlider.value)
        if styleSliderValue == 0 {
            // Don't scale at all
            font = UIFont(name: postscriptName, size: fontSize)!
            style = ".none"
            scaleFactor = "n/a"
            scaledSize = "n/a"
    
            fontStyleLabel.text = "Style: .none"
        } else {
            // Scale for selected UIFont.TextStyle
            let fontStyleIndex = styleSliderValue - 1
            let selectedTextStyle = UIFont.TextStyle.allCases[fontStyleIndex]
            
            font = FontUtil.createScaledFont(
                name: postscriptName,
                size: fontSize,
                textStyle: selectedTextStyle,
                contentSizeCategory: contentSizeCategory
            )
            style = selectedTextStyle.title
            scaleFactor = (font.pointSize / fontSize).formatAsPercent()
            scaledSize = "\(font.pointSize)"
        }
        
        let lineHeightRatio: CGFloat = font.lineHeight / font.pointSize
        
        contentSizeCategoryLabel.text = "\(sizeCategory)"
        fontLabel.text = "\(postscriptName), lh %:(\(lineHeightRatio.formatAsPercent()))"
        fontSizeLabel.text = "Size: \(fontSize)"
        fontStyleLabel.text = "Style: \(style)"
        fontInfoLabel.text = """
        Scale Factor: \(scaleFactor)
        Scaled: (size: \(scaledSize), lineHeight: \(font.lineHeight))
        """
        textView.font = font
    }
    
    @objc func fontSliderChanged(_ sender: UISlider) {
        updateTextViewFont()
    }
    
    @objc func contentSizeCategorySliderChanged(_ sender: UISlider) {
        updateTextViewFont()
    }
    
    @objc func fontSizeSliderChanged(_ sender: UISlider) {
        updateTextViewFont()
    }
    
    @objc func fontStyleSliderChanged(_ sender: UISlider) {
        updateTextViewFont()
    }

    @objc func preferredContentSizeChanged(_ notification: Notification) {
        updateTextViewFont()
    }
    
    
    
}

extension CGFloat {
    func formatAsPercent() -> String {
        let percentageValue = self * 100
        return String(format: "%.000f%%", percentageValue)
    }
}
