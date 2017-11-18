//
//  WindowController.swift
//  Sportball
//
//  Created by Aaron Vontell and Tej Patel on 11/16/17.
//  Copyright © 2017 Vontech Software, LLC. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSTouchBarDelegate {
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        guard let viewController = contentViewController as? ViewController else {
            return nil
        }
        return viewController.makeTouchBar()
    }
    
}

