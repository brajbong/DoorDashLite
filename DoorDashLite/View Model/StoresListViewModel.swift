//
//  StoresListViewModel.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/15/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import UIKit

class StoresListViewModel {
    var stores = [Store]()
    private var storeService: StoreService
    private var imageService: ImageService
    var mapCoordinates = (latitude: 0.0, longitude: 0.0)
    
    init(storeService: StoreService, imageService: ImageService) {
        self.storeService = storeService
        self.imageService = imageService
    }
    
    func getStores(completion: @escaping (Bool) -> Void) {
        storeService.fetchStores(lat: mapCoordinates.latitude, long: mapCoordinates.longitude)
        { [weak self] stores in
            if let self = self {
                self.stores = stores
                if !self.stores.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func fetchImage(for imageUrl: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: imageUrl) else { return }
        imageService.fetchImage(for: url) { image in
            guard let image = image else {
                completion(UIImage())
                return
            }
            completion(image)
        }
    }
}
