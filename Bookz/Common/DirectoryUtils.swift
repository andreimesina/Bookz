//
//  DirectoryUtils.swift
//  Bookz
//
//  Created by Andrei Mesina on 10/05/2020.
//  Copyright © 2020 Andrei Mesina. All rights reserved.
//

import Foundation

class DirectoryUtils {
    
    static func getAppSupportDirectoryPath() -> String? {
        guard let appSupportDirectory = NSSearchPathForDirectoriesInDomains(
            .applicationSupportDirectory,
            .userDomainMask,
            true
        ).first else {
            return nil
        }
        
        checkAndCreateDirectory(path: appSupportDirectory)
        return appSupportDirectory
    }
    
    static func getAppSupportDirectoryURL() -> URL? {
        guard let appSupportDirectory = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            return nil
        }
        
        checkAndCreateDirectory(path: appSupportDirectory.absoluteString)
        return appSupportDirectory
    }

    static func checkAndCreateDirectory(path: String) {
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.createDirectory(
                    atPath: path,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
            } catch {
                print(error)
            }
        }
    }
    
    static func isFileExisting(path: String) -> Bool {
        let fileManager = FileManager.default
        
        if (fileManager.fileExists(atPath: path)) {
            return true
        }
        
        return false
    }
    
    static func isFileExisting(url: URL) -> Bool {
        let fileManager = FileManager.default
        
        if (fileManager.fileExists(atPath: url.path)) {
            return true
        }
        
        return false
    }
}
