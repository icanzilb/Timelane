//
//  AdController.swift
//  Timelane
//
//  Created by Marin Todorov on 1/26/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import AppKit

class AdController: NSObject {
    private var adView: NSImageView!
    
    private struct Ad {
        let imageURL: URL
        let targetURL: URL
    }
    private let ads: [Ad] = [
        Ad(imageURL: Bundle.main.url(forResource: "combinebook", withExtension: "png")!, targetURL: URL(string: "http://underplot.com/book.php?combine")!),
        Ad(imageURL: Bundle.main.url(forResource: "rxbook", withExtension: "png")!, targetURL: URL(string: "http://underplot.com/book.php?rxswift")!),
    ]
    
    private var currentAdIndex = 0
    
    func setView(_ adView: NSImageView) {
        self.adView = adView
        adView.addGestureRecognizer(
            NSClickGestureRecognizer(target: self, action: #selector(openURL))
        )
        setContext("Initial")
    }
    
    func setContext(_ context: String) {
        switch context {
        case "Combine": currentAdIndex = 0
        case "Other": currentAdIndex = 1
        default: currentAdIndex = 0
        }
        adView.image = NSImage(contentsOf: ads[currentAdIndex].imageURL)
    }
    
    @objc func openURL() {
        NSWorkspace.shared.open(ads[currentAdIndex].targetURL)
    }
}
