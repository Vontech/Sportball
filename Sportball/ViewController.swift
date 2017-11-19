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

struct GameResponse: Decodable {
    let week: Int
    let games: [DGame]
}

struct DGame: Decodable {
    let eid: String
    let gsis: String
    let d: String
    let t: String
    let q: String
    let h: String
    let hnn: String
    let hs: String
    let v: String
    let vnn: String
    let vs: String
    let rz: String
    let ga: String
    let gt: String
}

@available(OSX 10.12.2, *)
class ViewController: NSViewController {
    
    // Instantiate list of games
    var games: [String: DGame] = [:]
    
    // Instantiate list of colors for each team
    var colors: [String : NSColor] = [
        "cardinals": NSColor(hexString: "#B0063A")!,
        "falcons": NSColor(hexString: "#A6192E")!,
        "ravens": NSColor(hexString: "#241773")!,
        "bills": NSColor(hexString: "#C8102E")!,
        "panthers": NSColor(hexString: "#0085CA")!,
        "bears": NSColor(hexString: "#DC4405")!,
        "bengals": NSColor(hexString: "#FC4C02")!,
        "browns": NSColor(hexString: "#382F2D")!,
        "cowboys": NSColor(hexString: "#041E42")!,
        "broncos": NSColor(hexString: "#FC4C02")!,
        "lions": NSColor(hexString: "#0069B1")!,
        "packers": NSColor(hexString: "#175E33")!,
        "texans": NSColor(hexString: "#A6192E")!,
        "colts": NSColor(hexString: "#001489")!,
        "jaguars": NSColor(hexString: "#D49F12")!,
        "chiefs": NSColor(hexString: "#C8102E")!,
        "chargers": NSColor(hexString: "#0C2340")!,
        "rams": NSColor(hexString: "#866D4B")!,
        "dolphins": NSColor(hexString: "#008E97")!,
        "vikings": NSColor(hexString: "#512D6D")!,
        "patriots": NSColor(hexString: "#C8102E")!,
        "saints": NSColor(hexString: "#A28D5B")!,
        "giants": NSColor(hexString: "#001E62")!,
        "jets": NSColor(hexString: "#0C371D")!,
        "raiders": NSColor(hexString: "#101820")!,
        "eagles": NSColor(hexString: "#064C53")!,
        "steelers": NSColor(hexString: "#FFB81C")!,
        "49ers": NSColor(hexString: "#9B2743")!,
        "seahawks": NSColor(hexString: "#245998")!,
        "buccaneers": NSColor(hexString: "#C8102E")!,
        "titans": NSColor(hexString: "#4B92DB")!,
        "redskins": NSColor(hexString: "#862633")!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let response: GameResponse = (try getScores())!
            for game in response.games {
                games[game.eid] = game
            }
        } catch {
            games = [:]
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
    
    func getScores() throws -> GameResponse? {
        let dataAddress = "http://vontech.org/api/sportball"
        let url = URL(string: dataAddress)!
        let jsonData = try Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        let response = try jsonDecoder.decode(GameResponse.self, from: jsonData)
        return response
    }
    
    func getTeamIdentifierFromGame(game: DGame) -> NSTouchBarItem.Identifier {
        return NSTouchBarItem.Identifier("org.vontech.TeamLabel:" + game.eid)
    }
    
    func getScoreIdentifierFromGame(game: DGame) -> NSTouchBarItem.Identifier {
        return NSTouchBarItem.Identifier("org.vontech.ScoreLabel:" + game.eid)
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
    
    // Why doesn't this work?
    func imageFromTextField(_ textField : NSTextField) -> NSImage {
        
        let myRect : NSRect = view.bounds
        let imgSize : NSSize = myRect.size
        
        let bir : NSBitmapImageRep = textField.bitmapImageRepForCachingDisplay(in: myRect)!
        bir.size = imgSize
        textField.cacheDisplay(in: myRect, to: bir)
        
        let image : NSImage = NSImage(size: imgSize)
        image.addRepresentation(bir)

        return image;
        
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .sportballBar
        touchBar.defaultItemIdentifiers = [.titleLabelItem, .fixedSpaceSmall]
        touchBar.customizationAllowedItemIdentifiers = [.titleLabelItem]
        
        for game in self.games.keys {
            let g = self.games[game]
            touchBar.defaultItemIdentifiers.append(getTeamIdentifierFromGame(game: g!))
            touchBar.defaultItemIdentifiers.append(getScoreIdentifierFromGame(game: g!))
        }
        
        if self.games.count == 0 {
            touchBar.defaultItemIdentifiers.append(.errorLabelItem)
        }
        
        return touchBar
        
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        let comps = identifier.rawValue.components(separatedBy: ":")
        let type = comps[0]
        
        switch type {
        case NSTouchBarItem.Identifier.titleLabelItem.rawValue:
            // If it was the title, add the title
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "Sportball")
            return customViewItem
        case NSTouchBarItem.Identifier.errorLabelItem.rawValue:
            // If it was the title, add the title
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "No games are currently available; please try again later.")
            return customViewItem
        case NSTouchBarItem.Identifier.teamLabelItem.rawValue:
            // If it was not anything from above, it must be a game, so add it!
            let game: DGame = self.games[comps[1]]!
            let title = game.h + " vs. " + game.v
            
            let gameItem = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton(title: title, target: self, action: #selector(clickGame(_:)))
            button.bezelColor = self.colors[game.hnn]
            gameItem.view = button
            return gameItem
        case NSTouchBarItem.Identifier.scoreLabelItem.rawValue:
            let customActionItem = NSCustomTouchBarItem(identifier: identifier)

            //let teamOneImage = NSImage(named: NSImage.Name.removeTemplate)!
            //let teamTwoImage = NSImage(named: NSImage.Name.addTemplate)!
            let game: DGame = self.games[comps[1]]!
            let teamOneScore = String(game.hs)
            let teamTwoScore = String(game.vs)

            let segmentedControl = NSSegmentedControl(labels: [teamOneScore, teamTwoScore], trackingMode: .momentary, target: self, action: #selector(clickGame(_:)))
            segmentedControl.setWidth(40, forSegment: 0)
            segmentedControl.setWidth(40, forSegment: 1)
            customActionItem.view = segmentedControl
            return customActionItem
        default:
            return nil
        }
    }
    
}

