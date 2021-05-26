//
//  AccountsCredsDependency.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

struct AccountsCredsDependency {
    
    let parentController: UIViewController
    let onTerminate: ((AuthCredRealmObject) -> Void)?
}
