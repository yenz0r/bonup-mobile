//
//  AddCompanyInputRowModel.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

enum AddCompanyInputRowModelType {
    case title

    case ownerName
    case ownerSecondName
    case ownerLastName

    case country
    case city
    case street
    case houseNumber

    case phone

    case vkLink
    case webSite

    case descriptionInfo

    var title: String {

        switch self {

        case .title:
            return "ui_company_title_label"
        case .ownerName:
            return "ui_company_owner_name_label"
        case .ownerSecondName:
            return "ui_company_owner_second_name_label"
        case .ownerLastName:
            return "ui_company_owner_last_name_label"
        case .country:
            return "ui_company_location_country_label"
        case .city:
            return "ui_company_location_city_label"
        case .street:
            return "ui_company_location_street_label"
        case .houseNumber:
            return "ui_company_location_house_number_label"
        case .phone:
            return "ui_company_contacts_phone_label"
        case .vkLink:
            return "ui_company_contacts_vk_link_label"
        case .webSite:
            return "ui_company_contacts_web_site_label"
        case .descriptionInfo:
            return "ui_company_description_label"
        }
    }
}

struct AddCompanyInputRowModel {

    let rowType: AddCompanyInputRowModelType
    var value: String? = nil
}
