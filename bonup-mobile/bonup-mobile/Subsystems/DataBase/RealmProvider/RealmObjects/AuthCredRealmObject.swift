//
//  AuthCredRealmObject.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class AuthCredRealmObject: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var email = ""
}
