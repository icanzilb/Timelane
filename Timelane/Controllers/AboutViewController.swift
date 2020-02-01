//
//  AboutViewController.swift
//  Timelane
//
//  Created by Marin Todorov on 1/26/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import AppKit
import Down

class AboutViewController: NSViewController {
    @IBOutlet var timelaneLabel: NSTextField!
    @IBOutlet var textView: NSTextView!
    
    let textURL = Bundle.main.url(forResource: "about", withExtension: "txt")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelaneLabel.stringValue.append(contentsOf: " \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)")
        textView.string = try! String(contentsOf: textURL)
    }
    
    @IBAction func openTimelaneTools(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "http://timelane.tools")!)
    }
}
