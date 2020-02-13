//
//  AppDelegate.swift
//  Timelane
//
//  Created by Marin Todorov on 1/26/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Cocoa
import AppMover

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        #if !DEBUG
        AppMover.moveIfNecessary()
        #endif
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
