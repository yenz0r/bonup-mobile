//
//  Bundle+Localization.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import ObjectiveC

var kBundleKey = "bundle-key-for-localization-bonup"

class BundleEx: Bundle {

    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {

        if let bundle: Bundle = objc_getAssociatedObject(self, &kBundleKey) as? Bundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

extension Bundle {

    static let once: AnyClass? = {
        object_setClass(Bundle.main, BundleEx.self)
    }()

    static func set(language: String) {

        _ = once
        let value = Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj") ?? "ru.lproj")
        objc_setAssociatedObject(Bundle.main,
                                 &kBundleKey,
                                 value,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
