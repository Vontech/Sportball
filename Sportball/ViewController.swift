//
//  ViewController.swift
//  Sportball
//
//  Created by Aaron Vontell and Tej Patel on 11/16/17.
//  Copyright © 2017 Vontech Software, LLC. All rights reserved.
//

import Cocoa

// For now I am putting the class definition for games in this file, but ideally
// we should move this elsewhere later

@available(OSX 10.12.2, *)
class Game {
    
    var identifier, teamOneName, teamTwoName : String
    var teamOneScore, teamTwoScore : Int
    var teamOneColor, teamTwoColor : NSColor
    var teamOneImage, teamTwoImage : String
    var touchBarIdentifier : NSTouchBarItem.Identifier
    
    init(identifier: String, teamOneName: String, teamTwoName: String,
         teamOneColor: NSColor, teamTwoColor: NSColor, teamOneImage: String,
         teamTwoImage: String) {
        self.identifier = identifier
        self.touchBarIdentifier = NSTouchBarItem.Identifier("org.vontech.GameLabel:" + identifier)
        self.teamOneName = teamOneName
        self.teamTwoName = teamTwoName
        self.teamOneColor = teamOneColor
        self.teamTwoColor = teamTwoColor
        self.teamOneImage = teamOneImage
        self.teamTwoImage = teamTwoImage
        self.teamOneScore = 0
        self.teamTwoScore = 0
    }
    
}

@available(OSX 10.12.2, *)
class ViewController: NSViewController {
    
    var games: [NSTouchBarItem.Identifier: Game] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // TEST
        let testColor = NSColor(red:0.35, green:0.61, blue:0.35, alpha:1.00)
        let testImage = "http://google.com/"
        for i in 1...10 {
            let ident = String(i)
            let newGame1 = Game(identifier: ident, teamOneName: "Celtics", teamTwoName: "Lakers", teamOneColor: testColor, teamTwoColor: testColor, teamOneImage: testImage, teamTwoImage: testImage)
            games[newGame1.touchBarIdentifier] = newGame1
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func clickGame(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case 0:
            print("Click 1")
        case 1:
            print("Click 2")
        default:
            break
        }
    }

}

// MARK: - Scrubber DataSource & Delegate

// WE WILL WANT TO USE THIS FOR HOLDING ALL OF THE GAMES

//@available(OSX 10.12.2, *)
//extension ViewController: NSScrubberDataSource, NSScrubberDelegate {
//
//    func numberOfItems(for scrubber: NSScrubber) -> Int {
//        return 5
//    }
//
//    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
//        let itemView = scrubber.makeItem(withIdentifier: "RatingScrubberItemIdentifier", owner: nil) as! NSScrubberTextItemView
//        itemView.textField.stringValue = String(index)
//        return itemView
//    }
//
//    func scrubber(_ scrubber: NSScrubber, didSelectItemAt index: Int) {
//        willChangeValue(forKey: "rating")
//        rating = index
//        didChangeValue(forKey: "rating")
//    }
//
//}

// MARK: - TouchBar Delegate

@available(OSX 10.12.2, *)
extension ViewController: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .sportballBar
        touchBar.defaultItemIdentifiers = [.titleLabelItem, .fixedSpaceSmall]
        touchBar.customizationAllowedItemIdentifiers = [.titleLabelItem]
        
        for game in self.games.keys {
            touchBar.defaultItemIdentifiers.append(game)
        }
        
        return touchBar
        
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItem.Identifier.titleLabelItem:
            // If it was the title, add the title
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "Sportball")
            return customViewItem
        case NSTouchBarItem.Identifier.configLabelItem:
            let customActionItem = NSCustomTouchBarItem(identifier: identifier)
            let segmentedControl = NSSegmentedControl(images: [NSImage(named: NSImage.Name.removeTemplate)!, NSImage(named: NSImage.Name.addTemplate)!], trackingMode: .momentary, target: self, action: #selector(clickGame(_:)))
            //segmentedControl.bezelColor = NSColor(red:0.35, green:0.61, blue:0.35, alpha:1.00)
            segmentedControl.setWidth(40, forSegment: 0)
            segmentedControl.setWidth(40, forSegment: 1)
            customActionItem.view = segmentedControl
            return customActionItem
        default:
            // If it was not anything from above, it must be a game, so add it!
            let game = self.games[identifier]
            let title = game!.teamOneName + " vs. " + game!.teamTwoName
            
            let gameItem = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton(title: title, target: self, action: #selector(clickGame(_:)))
            button.bezelColor = game!.teamTwoColor
            gameItem.view = button
            return gameItem
            
            //let customActionItem = NSCustomTouchBarItem(identifier: identifier)
            //let segmentedControl = NSSegmentedControl(images: [NSImage(named: NSImage.Name.removeTemplate)!, NSImage(named: NSImage.Name.addTemplate)!], trackingMode: .momentary, target: self, action: #selector(clickGame(_:)))
            //segmentedControl.bezelColor = NSColor(red:0.35, green:0.61, blue:0.35, alpha:1.00)
            //segmentedControl.setWidth(40, forSegment: 0)
            //segmentedControl.setWidth(40, forSegment: 1)
            //customActionItem.view = segmentedControl
            //return customActionItem
        }
    }
    
}

