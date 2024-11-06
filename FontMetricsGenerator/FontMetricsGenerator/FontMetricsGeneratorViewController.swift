//
//  ViewController.swift
//  FontMetricsGenerator
//
//  Created by Andrew McLean on 10/18/24.
//

import UIKit
import SharedFonts

class FontMetricsGeneratorViewController: UIViewController {

    let stackView: UIStackView = .init(axis: .vertical, spacing: 20)
    
    let fontMetricsTypeButton: UIButton = .init(configuration: .filled())
    let dynamicTypeButton: UIButton = .init(configuration: .filled())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        fontMetricsTypeButton.setTitle("Generate System Font Metrics", for: .normal)
        fontMetricsTypeButton.addAction(.init(handler: { [weak self] _ in
            self?.generateFontMetrics()
        }), for: .touchUpInside)
        
        dynamicTypeButton.setTitle("Generate Dynamic Type Metrics", for: .normal)
        dynamicTypeButton.addAction(.init(handler: { [weak self] _ in
            self?.generateDynamicTypeMetrics()
        }), for: .touchUpInside)
        
        stackView.addArrangedSubview(fontMetricsTypeButton)
        stackView.addArrangedSubview(dynamicTypeButton)
        view.addSubview(stackView)
        stackView.centerInSuperview()
    }

    func generateFontMetrics() {
        let generator = FontMetricsGenerator()
        generator.generateSystemMetrics()
    }
    
    func generateDynamicTypeMetrics() {
        let generator = FontMetricsGenerator()
        generator.generateDynamicTypeMetrics()
    }
}

