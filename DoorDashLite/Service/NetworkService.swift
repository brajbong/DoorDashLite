//
//  NetworkService.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/15/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import Foundation

final class NetworkService: Networking {
    private let session: NetworkSession

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch(resource: Resource, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let request = makeRequest(for: resource) else {
            completion(.failure(.badURL))
            return
        }
        
        session.dataTask(with: request) { result in
            completion(result)
        }
    }
    
    private func makeRequest(for resource: Resource) -> URLRequest? {
        let url = resource.path.map {
            resource.url.appendingPathComponent($0)
        } ?? resource.url
        
        guard var component = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        component.queryItems = resource.parameters.map({
            return URLQueryItem(name: $0, value: $1)
        })
        
        guard let resolvedUrl = component.url else { return nil }
        var request = URLRequest(url: resolvedUrl)
        request.httpMethod = resource.httpMethod.rawValue
        return request
    }
}
