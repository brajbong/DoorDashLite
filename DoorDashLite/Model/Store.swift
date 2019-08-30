//
//  Store.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/15/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import Foundation

class Store: Decodable {
    var id: Int = 0
    var name: String = ""
    var description: String = ""
    var delivery_fee: Int = 0
    var cover_img_url: String = ""
    var asap_time: Int = 0
    
    static func make(data: Data) -> [Store]? {
        return try? JSONDecoder().decode([Store].self, from: data)
    }
}

extension Store {
    convenience init(id: Int, name: String, description: String, delivery_fee: Int,
         cover_image_url: String, asap_time: Int) {
        self.init()
        self.id = id
        self.name = name
        self.description = description
        self.delivery_fee = delivery_fee
        self.cover_img_url = cover_image_url
        self.asap_time = asap_time
    }
}
