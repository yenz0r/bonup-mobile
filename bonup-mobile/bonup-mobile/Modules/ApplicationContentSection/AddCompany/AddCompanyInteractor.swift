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
    private let initCompany: CompanyEntity?
    
    private lazy var networkProvider = MainNetworkProvider<AddCompanyService>()
    private lazy var validator = Validator()
    
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
                        
                        if let string = row.value,
                           self.validator.sdonlyLetters(string) {
                         
                            requestModel.title = string
                        }
                        else {
                            
                            failure?(self.validationError(.title))
                            return
                        }
                        
                    case .ownerName:
                        
                        if let string = row.value,
                           self.validator.onlyLetters(string),
                           self.validator.onlySingleWord(string) {
                         
                            requestModel.directorFirstName = string
                        }
                        else {
                            
                            failure?(self.validationError(.ownerName))
                            return
                        }
                        
                    case .ownerSecondName:
                        
                        if let string = row.value,
                           self.validator.onlyLetters(string),
                           self.validator.onlySingleWord(string) {
                         
                            requestModel.directorSecondName = string
                        }
                        else {
                            
                            failure?(self.validationError(.ownerSecondName))
                            return
                        }
                        
                    case .ownerLastName:
                        
                        if let string = row.value,
                           self.validator.onlyLetters(string),
                           self.validator.onlySingleWord(string) {
                         
                            requestModel.directorLastName = string
                        }
                        else {
                            
                            failure?(self.validationError(.ownerLastName))
                            return
                        }
                        
                    case .country:
                        
                        if let string = row.value,
                           self.validator.onlyLetters(string),
                           self.validator.onlySingleWord(string) {
                         
                            requestModel.locationCountry = string
                        }
                        else {
                            
                            failure?(self.validationError(.country))
                            return
                        }
                        
                    case .city:
                        
                        if let string = row.value,
                           self.validator.onlyLetters(string),
                           self.validator.onlySingleWord(string) {
                         
                            requestModel.locationCity = string
                        }
                        else {
                            
                            failure?(self.validationError(.city))
                            return
                        }
                        
                    case .street:
                        
                        if let string = row.value,
                           self.validator.onlyLetters(string),
                           self.validator.onlySingleWord(string) {
                         
                            requestModel.locationStreet = string
                        }
                        else {
                            
                            failure?(self.validationError(.street))
                            return
                        }
                        
                    case .houseNumber:
                        
                        if let string = row.value,
                           self.validator.onlyNumbers(string),
                           self.validator.onlySingleWord(string) {
                         
                            requestModel.locationHomeNumber = string
                        }
                        else {
                            
                            failure?(self.validationError(.houseNumber))
                            return
                        }
                        
                    case .phone:
                        
                        if let string = row.value,
                           self.validator.isPhoneNumber(string) {
                         
                            requestModel.contactsPhone = string
                        }
                        else {
                            
                            failure?(self.validationError(.phone))
                            return
                        }
                        
                    case .vkLink:
                        
                        requestModel.contactsVK = row.value ?? ""
                        
                    case .webSite:
                        
                        requestModel.contactsWebSite = row.value ?? ""
                        
                    case .descriptionInfo:
                        
                        if let descriptionText = row.value {
                         
                            requestModel.descriptionText = descriptionText
                        }
                        else {
                            
                            failure?(self.validationError(.descriptionInfo))
                            return
                        }
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
    
    // MARK: - Private
    
    private func validationError(_ rowType: AddCompanyInputRowModelType) -> String {
        
        return "\(rowType.title.localized) \("ui_validation_faild".localized)"
    }
}
