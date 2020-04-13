//
//  AppDelegate.swift
//  Timelane
//
//  Created by Marin Todorov on 1/26/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Cocoa
import AppMover
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let updater = SUUpdater()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        #if !DEBUG
        AppMover.moveIfNecessary()
        #endif
        updater.delegate = self
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func checkForUpdates(_ sender: Any) {
        updater.checkForUpdates(sender)
    }
}

extension AppDelegate: SUUpdaterDelegate {
    func updaterShouldPromptForPermissionToCheck(forUpdates updater: SUUpdater) -> Bool {
        return false
    }
}
