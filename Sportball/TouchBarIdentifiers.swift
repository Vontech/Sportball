//
//  TouchBarIdentifiers.swift
//  Sportball
//
//  Created by Aaron Vontell and Tej Patel on 11/17/17.
//  Copyright © 2017 Vontech Software, LLC. All rights reserved.
//

import AppKit

@available(OSX 10.12.2, *)
extension NSTouchBarItem.Identifier {
    static let configLabelItem = NSTouchBarItem.Identifier("org.vontech.InfoLabel")
    static let titleLabelItem = NSTouchBarItem.Identifier("org.vontech.TitleLabel")
    static let teamLabelItem = NSTouchBarItem.Identifier("org.vontech.TeamLabel")
    static let scoreLabelItem = NSTouchBarItem.Identifier("org.vontech.ScoreLabel")
    static let errorLabelItem = NSTouchBarItem.Identifier("org.vontech.ErrorLabel")
}

@available(OSX 10.12.2, *)
extension NSTouchBar.CustomizationIdentifier {
    static let sportballBar = NSTouchBar.CustomizationIdentifier("org.vontech.ViewController.SportballBar")
}
