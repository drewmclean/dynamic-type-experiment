//
//  File.swift
//
//
//  Created by Andrew McLean on 10/18/24.
//

import CoreText
import UIKit
import Foundation

public struct FontLoader {
    
    public static var fontNames: [String] = []
    
    public static func loadFonts() {
        fontNames = []
        // Get the URL for the Fonts folder within the package resources
        let bundle = Bundle.module
        
        do {
            // Enumerate the contents of the folder
            guard
                let otfURLs: [URL] = bundle.urls(forResourcesWithExtension: "otf", subdirectory: nil),
                let ttfURLs: [URL] = bundle.urls(forResourcesWithExtension: "ttf", subdirectory: nil)
            else {
                return
            }
            
            let fontURLs: [URL] = otfURLs + ttfURLs
            
            // Register each font file
            for url in fontURLs {
                var error: Unmanaged<CFError>?
                
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success, let error = error?.takeUnretainedValue() {
                    print("Failed to load font at \(url.lastPathComponent): \(error.localizedDescription)")
                    continue
                } else {
//                    print("Successfully loaded font: \(url.lastPathComponent)")
                }
                
                
                // Step 1: Create a data provider from the font file URL
                guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
                    print("Failed to create data provider for font at \(url).")
                    continue
                }
                
                // Step 2: Create a CGFont object from the data provider
                guard let cgFont = CGFont(fontDataProvider) else {
                    print("Failed to create CGFont from data provider.")
                    continue
                }
                
                // Step 3: Get the PostScript name of the font
                if let postScriptName = cgFont.postScriptName {
                    fontNames.append(postScriptName as String)
                } else {
                    print("Failed to get PostScript name for font at \(url).")
                }
                fontNames = fontNames.sorted(by: <)
            }
        } catch {
            print("Error enumerating fonts folder: \(error.localizedDescription)")
        }
    }
    
}
