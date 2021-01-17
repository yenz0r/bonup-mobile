//
//  AddCompanyInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IAddCompanyInteractor: AnyObject {

    var inputSections: [AddCompanyInputSectionModel] { get }
}

final class AddCompanyInteractor {

    // MARK: - Initialization

    init() {
        
        self.sections = [
            self.configureTitleInfoSection(),
            self.configureOwnerInfoSection(),
            self.configureLocationInfoSection(),
            self.configureContactsInfoSection(),
            self.configureDescriptionInfoSection()
        ]
    }

    // MARK: - Private variables

    var sections: [AddCompanyInputSectionModel] = []

    // MARK: - Configure

    private func configureTitleInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(rowType: .title)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_title_label".localized)
    }

    private func configureOwnerInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(rowType: .ownerName),
            AddCompanyInputRowModel(rowType: .ownerSecondName),
            AddCompanyInputRowModel(rowType: .ownerLastName)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_owner_info_label".localized)
    }

    private func configureLocationInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(rowType: .country),
            AddCompanyInputRowModel(rowType: .city),
            AddCompanyInputRowModel(rowType: .street),
            AddCompanyInputRowModel(rowType: .houseNumber)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_location_info_label".localized)
    }

    private func configureContactsInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(rowType: .phone),
            AddCompanyInputRowModel(rowType: .vkLink),
            AddCompanyInputRowModel(rowType: .webSite)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_contacts_info_label".localized)
    }

    private func configureDescriptionInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(rowType: .descriptionInfo)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_description_info_label".localized)
    }
}

// MARK: - IAddCompanyInteractor implementation

extension AddCompanyInteractor: IAddCompanyInteractor {

    var inputSections: [AddCompanyInputSectionModel] {

        return self.sections
    }
}
