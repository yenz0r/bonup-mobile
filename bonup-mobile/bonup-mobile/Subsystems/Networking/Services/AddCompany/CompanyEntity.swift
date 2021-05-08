//
//  AddCompanyRequestEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 3.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

struct CompanyEntity: Codable {

    var title: String = ""
    var descriptionText: String = ""
    var directorFirstName: String = ""
    var directorSecondName: String = ""
    var directorLastName: String = ""
    var locationCountry: String = ""
    var locationCity: String = ""
    var locationStreet: String = ""
    var locationHomeNumber: String = ""
    var contactsPhone: String = ""
    var contactsVK: String = ""
    var contactsWebSite: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var categoryId: Int = 0
}
