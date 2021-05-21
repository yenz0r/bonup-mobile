//
//  AddressPickerDependency.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

struct AddressPickerDependency {

    let parentController: UIViewController
    let initAdderss: String?
    let searchManager = MapSearchManager()
    let suggestsManager = MapSuggestsManager()
}
