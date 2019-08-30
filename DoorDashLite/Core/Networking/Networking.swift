//
//  Networking.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/15/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import Foundation

protocol Networking {
    func fetch(resource: Resource, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
