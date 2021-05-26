//
//  CategoriesDependency.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

struct CategoriesDependency {
    
    enum Target {
    
        case settings, login
    }
    
    let parentViewController: UIViewController
    let target: Target
}
