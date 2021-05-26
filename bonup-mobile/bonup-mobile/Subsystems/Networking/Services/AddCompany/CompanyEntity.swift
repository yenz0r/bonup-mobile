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
    var address: String = ""
    var contactsPhone: String = ""
    var contactsVK: String = ""
    var contactsWebSite: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var categoryId: Int = 0
    var availableTasksCount: Int = 0
    var availableCouponsCount: Int = 0
    var availableStocksCount: Int = 0
    var photoId: Int = 0
}
