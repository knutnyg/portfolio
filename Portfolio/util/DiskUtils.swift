//
// Created by Knut Nygaard on 01/03/16.
// Copyright (c) 2016 APM solutions. All rights reserved.
//

import Foundation

func loadConfig() -> NSDictionary? {
    if let path = NSBundle.mainBundle().pathForResource("config", ofType: "plist") {
        return NSDictionary(contentsOfFile: path)
    } else {
        print("ERROR: Missing config file!")
        return nil
    }
}

func getFileURL(fileName: String) -> NSURL? {
    do {
        return try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false).URLByAppendingPathComponent(fileName)
    } catch {
        print("Error loading file from device...")
    }
    return nil
}

func synced(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}