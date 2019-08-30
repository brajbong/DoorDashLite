//
//  StoresListViewController.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/15/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import UIKit

class StoresListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var viewModel : StoresListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStoreDetails()
    }
    
    func fetchStoreDetails() {
        viewModel.getStores { result in
            if result {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.hideIndicator()
            }
        }
    }
    
    fileprivate func hideIndicator() {
        indicator.isHidden = true
        indicator.stopAnimating()
    }

}

extension StoresListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoresListCell.reuseIdentifier,
                                                 for: indexPath) as! StoresListCell
        cell.store = viewModel.stores[indexPath.row]
        return cell
    }
}
