//
//  CacheService.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/16/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import Foundation

final class CacheService {
    private let memory = NSCache<NSString, NSData>()
    private let diskPath: URL
    private let fileManager: FileManager
    private let serialQueue = DispatchQueue(label: "br.doordash")
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        do {
            let docDir = try fileManager.url(for: .documentDirectory, in: .userDomainMask,
                                             appropriateFor: nil, create: true)
            diskPath = docDir.appendingPathComponent("doordash")
            try createDirectoryIfNeeded()
        } catch {
            fatalError()
        }
    }
    
    func save(data: Data, key: String, completion: (() -> Void)? = nil) {
        serialQueue.async {
            self.memory.setObject(data as NSData, forKey: key as NSString)
            do {
                try data.write(to: self.filePath(key: key))
                completion?()
            } catch {
            }
        }
    }
    
    func load(key: String, completion: @escaping (Data?) -> Void) {
        serialQueue.async {
            //object present in memory
            if let data = self.memory.object(forKey: key as NSString) {
                completion(data as Data)
                return
            }
            
            //object present in disk
            if let data = try? Data(contentsOf: self.filePath(key: key)) {
                //set it back in memory
                self.memory.setObject(data as NSData, forKey: key as NSString)
                completion(data)
                return
            }
            
            completion(nil)
        }
    }
    
    fileprivate func filePath(key: String) -> URL {
        return diskPath.appendingPathComponent(key)
    }
    
    fileprivate func createDirectoryIfNeeded() throws {
        if !fileManager.fileExists(atPath: diskPath.path) {
            try fileManager.createDirectory(at: diskPath, withIntermediateDirectories: false, attributes: nil)
        }
    }
}
