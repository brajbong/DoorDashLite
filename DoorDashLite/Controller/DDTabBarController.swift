//
//  DDTabBarController.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/16/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import UIKit

class DDTabBarController: UITabBarController {
    var viewModel: StoresListViewModel = {
        let storesService = StoreService(networking: NetworkService())
        let imageService = ImageService(networkService: NetworkService(), cacheService: CacheService())
        return StoresListViewModel(storeService: storesService, imageService: imageService)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storesListVC = self.viewControllers?.first as! StoresListViewController
        storesListVC.viewModel = viewModel
    }

}
