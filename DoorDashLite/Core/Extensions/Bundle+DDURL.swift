//
//  Bundle+DDURL.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/17/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import Foundation

extension Bundle {
    subscript(key: String) -> [String: String]? {
        return self.infoDictionary?[key] as? [String : String]
    }
}

extension Bundle {
    static private let doorDashRootKey = "DoorDash"
    var listOfRestaurantsBaseURL: String {
        return (self[Bundle.doorDashRootKey]?["listOfRestaurantsBaseURL"])!
    }
    var listOfRestaurantsURLPath: String {
        return (self[Bundle.doorDashRootKey]?["listOfRestaurantsURLPath"])!
    }
}
