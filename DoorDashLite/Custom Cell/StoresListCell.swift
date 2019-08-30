//
//  StoresListCellTableViewCell.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/16/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import UIKit

class StoresListCell: UITableViewCell {
    enum Delivery {
        static let freeDelivery = "Free delivery"
        static let paidDelivery = "delivery"
    }
    
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeTitle: UILabel!
    @IBOutlet weak var storeDescription: UILabel!
    @IBOutlet weak var storeDelivery: UILabel!
    @IBOutlet weak var storeDeliveryTime: UILabel!
    
    private var imageService: ImageService?
    var store: Store? {
        didSet {
            self.imageService = ImageService(networkService: NetworkService(), cacheService: CacheService())
            setStoreData()
        }
    }
    
    static var reuseIdentifier: String {
        return "storesListCell"
    }
    
    private func setStoreData() {
        if let store = store {
            setImage(for: store.cover_img_url)
            storeTitle.text = store.name
            storeDescription.text = store.description
            if store.delivery_fee == 0 {
                storeDelivery.text = Delivery.freeDelivery
            } else {
                storeDelivery.text = deliveryFee(fee: store.delivery_fee)
            }
            storeDeliveryTime.text = deliveryTime(time: store.asap_time)
        }
    }
    
    private func setImage(for url: String) {
        guard let url = URL(string: url) else { return }
        self.imageService?.fetchImage(for: url) { image in
            DispatchQueue.main.async {
                self.storeImage.image = image
            }
        }
    }
    
    private func deliveryFee(fee: Int) -> String {
        let dollarAmt = Double(fee)/100
        if dollarAmt.truncatingRemainder(dividingBy: 1) == 0 {
            return "$\(Int(dollarAmt)) delivery"
        }
        return "$\(dollarAmt) delivery"
    }
    
    private func deliveryTime(time: Int) -> String {
        return "\(time) min"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
