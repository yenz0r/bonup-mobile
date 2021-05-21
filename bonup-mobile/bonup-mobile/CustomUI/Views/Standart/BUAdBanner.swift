//
//  BUAdBanner.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BUAdBanner: GADBannerView {
    
    // MARK: - Init
    
    init(rootViewController: UIViewController) {
        
        super.init(frame: .zero)
        
        self.adUnitID = GOOGLE_AD_KEY
        self.rootViewController = rootViewController
        self.load(GADRequest())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
