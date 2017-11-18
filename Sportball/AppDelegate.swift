//
//  AppDelegate.swift
//  Sportball
//
//  Created by Aaron Vontell and Tej Patel on 11/16/17.
//  Copyright © 2017 Vontech Software, LLC. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(OSX 10.12.2, *) {
            //NSApplication.shared().isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    }
    
}

