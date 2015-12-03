//
//  AppDelegate.swift
//  NineMenMorris
//
//  Created by John Eriksson on 2015-11-24.
//  Copyright © 2015 John Eriksson. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    
    func getSavedData() -> (Array<SKSpriteNode>, Array<SKSpriteNode>, Bool, Array<Int>, Int, Int, Int)? {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let blue = defaults.arrForKey("blue"), red = defaults.arrForKey("red"), removing = defaults.booleanForKey("removing"), gameplan = defaults.gameplanForKey("gameplan"), blueMarkers = defaults.intForKey("bluemarkers"), redMarkers = defaults.intForKey("redmarkers"), turn = defaults.intForKey("turn") {
            return (blue, red, removing, gameplan, blueMarkers, redMarkers, turn)
        }

        return nil
    }
    
    func saveData(blue: Array<SKSpriteNode>, red: Array<SKSpriteNode>, removing: Bool, gameplan: Array<Int>, blueMarkers: Int, redMarkers: Int, turn: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setArr(blue, forKey: "blue")
        defaults.setArr(red, forKey: "red")
        defaults.setBoolean(removing, forKey: "removing")
        defaults.setGameplan(gameplan, forKey: "gameplan")
        defaults.setInt(blueMarkers, forKey: "bluemarkers")
        defaults.setInt(redMarkers, forKey: "redmarkers")
        defaults.setInt(turn, forKey: "turn")
        defaults.synchronize()
    }
}

extension NSUserDefaults {
    
    func arrForKey(key: String) -> Array<SKSpriteNode>? {
        var obj: Array<SKSpriteNode>?
        if let data = dataForKey(key) {
            obj = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Array<SKSpriteNode>
        }
        return obj
    }
    
    func setArr(obj: Array<SKSpriteNode>?, forKey key: String) {
        var data: NSData?
        if let obj = obj {
            data = NSKeyedArchiver.archivedDataWithRootObject(obj)
        }
        setObject(data, forKey: key)
    }
    
    func booleanForKey(key: String) -> Bool? {
        var obj: Bool?
        if let data = dataForKey(key) {
            obj = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Bool
        }
        return obj
    }
    
    func setBoolean(obj: Bool?, forKey key: String) {
        var data: NSData?
        if let obj = obj {
            data = NSKeyedArchiver.archivedDataWithRootObject(obj)
        }
        setObject(data, forKey: key)
    }
    
    func intForKey(key: String) -> Int? {
        var obj: Int?
        if let data = dataForKey(key) {
            obj = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Int
        }
        return obj
    }
    
    func setInt(obj: Int?, forKey key: String) {
        var data: NSData?
        if let obj = obj {
            data = NSKeyedArchiver.archivedDataWithRootObject(obj)
        }
        setObject(data, forKey: key)
    }
    
    func gameplanForKey(key: String) -> Array<Int>? {
        var obj: Array<Int>?
        if let data = dataForKey(key) {
            obj = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Array<Int>
        }
        return obj
    }
    
    func setGameplan(obj: Array<Int>?, forKey key: String) {
        var data: NSData?
        if let obj = obj {
            data = NSKeyedArchiver.archivedDataWithRootObject(obj)
        }
        setObject(data, forKey: key)
    }
    
}

