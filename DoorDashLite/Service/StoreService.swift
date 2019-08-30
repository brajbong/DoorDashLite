//
//  StoreService.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/15/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import Foundation

enum ParamKeys: String {
    case lat
    case lng
}

enum ListOfStores {
    static let url = Bundle.main.listOfRestaurantsBaseURL
    static let path = Bundle.main.listOfRestaurantsURLPath
    static let httpMethod = HTTPMethod.get
    static let parameters = [ParamKeys.lat, ParamKeys.lng]
}

final class StoreService {
    private let baseUrl = URL(string: ListOfStores.url)!
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func fetchStores(lat: Double, long: Double, completion: @escaping ([Store]) -> Void) {
        let url = URL(string: ListOfStores.url)!
        let resource = Resource(url: url, path: ListOfStores.path,
                                httpMethod: HTTPMethod.get, parameters: parameters(lat: lat, long: long))
        return networking.fetch(resource: resource, completion: { result in
            if case .success(let data) = result {
                completion(Store.make(data: data) ?? [])
            }
        })
    }
    
    fileprivate func parameters(lat: Double, long: Double) -> [String: String] {
        var parameters = [String: String]()
        for param in ListOfStores.parameters {
            switch param {
            case ParamKeys.lat:
                parameters[ParamKeys.lat.rawValue] = String(lat)
            case ParamKeys.lng:
                parameters[ParamKeys.lng.rawValue] = String(long)
            }
        }
        return parameters
    }
}
