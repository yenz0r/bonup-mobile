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
    var selectedCategory: InterestCategories { get set }
    
    func updateValue(_ value: String?, at indexPath: IndexPath)
    
    func addCompany(success: (() -> Void)?, failure: ((String) -> Void)?)
}

final class AddCompanyInteractor {

    // MARK: - Initialization

    init() {
        
        self.selectedCategory = InterestCategories.food
        
        self.sections = [
            self.configureTitleInfoSection(),
            self.configureOwnerInfoSection(),
            self.configureLocationInfoSection(),
            self.configureContactsInfoSection(),
            self.configureDescriptionInfoSection()
        ]
    }

    // MARK: - Private variables

    private var sections: [AddCompanyInputSectionModel] = []
    var selectedCategory: InterestCategories = .food

    private lazy var networkProvider = MainNetworkProvider<AddCompanyService>()
    
    // MARK: - Configure

    private func configureTitleInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(rowType: .title)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_title_label")
    }

    private func configureOwnerInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(rowType: .ownerName),
            AddCompanyInputRowModel(rowType: .ownerSecondName),
            AddCompanyInputRowModel(rowType: .ownerLastName)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_owner_info_label")
    }

    private func configureLocationInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(rowType: .country),
            AddCompanyInputRowModel(rowType: .city),
            AddCompanyInputRowModel(rowType: .street),
            AddCompanyInputRowModel(rowType: .houseNumber)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_location_info_label")
    }

    private func configureContactsInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(rowType: .phone),
            AddCompanyInputRowModel(rowType: .vkLink),
            AddCompanyInputRowModel(rowType: .webSite)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_contacts_info_label")
    }

    private func configureDescriptionInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(rowType: .descriptionInfo)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_description_info_label")
    }
}

// MARK: - IAddCompanyInteractor implementation

extension AddCompanyInteractor: IAddCompanyInteractor {
    
    func updateValue(_ value: String?, at indexPath: IndexPath) {
        
        self.sections[indexPath.section].rows[indexPath.row].value = value
    }
    
    var inputSections: [AddCompanyInputSectionModel] {

        return self.sections
    }
    
    func addCompany(success: (() -> Void)?, failure: ((String) -> Void)?) {
        
        guard let token = AccountManager.shared.currentToken else {
            
            failure?("ui_error_title".localized)
            return
        }
        
        DispatchQueue.global(qos: .background).async {
         
            var requestModel = AddCompanyRequestEntity()
            for section in self.sections {
                
                for row in section.rows {
                    
                    switch row.rowType {
                    
                    case .title:
                        requestModel.title = row.value ?? ""
                        
                    case .ownerName:
                        requestModel.directorFirstName = row.value ?? ""
                        
                    case .ownerSecondName:
                        requestModel.directorSecondName = row.value ?? ""
                        
                    case .ownerLastName:
                        requestModel.directorLastName = row.value ?? ""
                        
                    case .country:
                        requestModel.locationCountry = row.value ?? ""
                        
                    case .city:
                        requestModel.locationCity = row.value ?? ""
                        
                    case .street:
                        requestModel.locationStreet = row.value ?? ""
                        
                    case .houseNumber:
                        requestModel.locationHomeNumber = row.value ?? ""
                        
                    case .phone:
                        requestModel.contactsPhone = row.value ?? ""
                        
                    case .vkLink:
                        requestModel.contactsVK = row.value ?? ""
                        
                    case .webSite:
                        requestModel.contactsWebSite = row.value ?? ""
                        
                    case .descriptionInfo:
                        requestModel.descriptionText = row.value ?? ""
                    }
                }
            }
            
            _ = self.networkProvider
                .requestBool(.addCompany(token: token, companyEntity: requestModel),
                             completion: { result in
                                
                                if result {
                                    
                                    success?()
                                }
                                else {
                                    
                                    failure?("ui_error_title".localized)
                                }
                                
                             }, failure: { _ in
                                
                                failure?("ui_error_title".localized)
                             })
        }
    }
}
