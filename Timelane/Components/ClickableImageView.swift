//
//  ClickableImageView.swift
//  Timelane
//
//  Created by Marin Todorov on 5/2/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Cocoa

class ClickableImageView: NSImageView {
    
    var trackingArea: NSTrackingArea?
    var onClick: (() -> Void)?
    
    // MARK: Mouse events
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        NSCursor.pointingHand.set()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        NSCursor.arrow.set()
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        NSCursor.arrow.set()
        onClick?()
    }
    
    override func updateTrackingAreas() {
        if let ta = trackingArea {
            removeTrackingArea(ta)
        }
        trackingArea = NSTrackingArea(rect: bounds,
                                      options: [.activeInKeyWindow, .mouseEnteredAndExited],
                                      owner: self,
                                      userInfo: nil)
        addTrackingArea(trackingArea!)
    }
}
