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
    var moduleMode: AddCompanyInteractor.ModuleMode { get }
    
    func updateValue(_ value: String?, at indexPath: IndexPath)
    
    func addCompany(success: (() -> Void)?, failure: ((String) -> Void)?)
}

final class AddCompanyInteractor {

    enum ModuleMode: Int {
        
        case add = 0, details
    }
    
    // MARK: - Initialization

    init(initCompany: CompanyEntity?) {
        
        self.initCompany = initCompany
        self.selectedCategory = .food
        
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
    private lazy var networkProvider = MainNetworkProvider<AddCompanyService>()
    private let initCompany: CompanyEntity?
    
    // MARK: - Public variables
    
    var selectedCategory: InterestCategories
    
    // MARK: - Configure

    private func configureTitleInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(value: self.initCompany?.title, rowType: .title)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_title_label")
    }

    private func configureOwnerInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(value: self.initCompany?.directorFirstName, rowType: .ownerName),
            AddCompanyInputRowModel(value: self.initCompany?.directorSecondName, rowType: .ownerSecondName),
            AddCompanyInputRowModel(value: self.initCompany?.directorLastName, rowType: .ownerLastName)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_owner_info_label")
    }

    private func configureLocationInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(value: self.initCompany?.locationCountry, rowType: .country),
            AddCompanyInputRowModel(value: self.initCompany?.locationCity, rowType: .city),
            AddCompanyInputRowModel(value: self.initCompany?.locationStreet, rowType: .street),
            AddCompanyInputRowModel(value: self.initCompany?.locationHomeNumber, rowType: .houseNumber)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_location_info_label")
    }

    private func configureContactsInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(value: self.initCompany?.contactsPhone, rowType: .phone),
            AddCompanyInputRowModel(value: self.initCompany?.contactsVK, rowType: .vkLink),
            AddCompanyInputRowModel(value: self.initCompany?.contactsWebSite, rowType: .webSite)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_contacts_info_label")
    }

    private func configureDescriptionInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(value: self.initCompany?.descriptionText, rowType: .descriptionInfo)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_description_info_label")
    }
}

// MARK: - IAddCompanyInteractor implementation

extension AddCompanyInteractor: IAddCompanyInteractor {
    
    var moduleMode: ModuleMode {
        
        return self.initCompany == nil ? .add : .details
    }
    
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
         
            var requestModel = CompanyEntity()
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
