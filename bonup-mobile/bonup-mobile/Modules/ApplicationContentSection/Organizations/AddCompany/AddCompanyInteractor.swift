//
//  AddCompanyInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit.UIImage

protocol IAddCompanyInteractor: AnyObject {

    var inputSections: [AddCompanyInputSectionModel] { get }
    var selectedCategory: InterestCategories { get set }
    var selectedPhoto: UIImage { get set }
    var moduleMode: AddCompanyDependency.Mode { get }
    var initCompany: CompanyEntity? { get }
    
    var companyLongitude: Double { get set }
    var companyLatitude: Double { get set }
    
    func updateValue(_ value: String?, at indexPath: IndexPath)
    
    func addCompany(success: (() -> Void)?, failure: ((String) -> Void)?)
}

final class AddCompanyInteractor {
    
    // MARK: - Public variables
    
    var companyLongitude: Double = 0
    var companyLatitude: Double = 0
    
    // MARK: - Initialization

    init(initCompany: CompanyEntity?,
         companyPacket: CompanyPacketType?,
         mode: AddCompanyDependency.Mode) {
        
        self.initCompany = initCompany
        self.selectedCategory = .food
        self.selectedPhoto = AssetsHelper.shared.image(.addImageIcon)!
        
        self.companyPacket = companyPacket
        self.moduleMode = mode
        
        self.sections = [
            self.configureTitleInfoSection(),
            self.configureOwnerInfoSection(),
            self.configureLocationInfoSection(),
            self.configureContactsInfoSection(),
            self.configureDescriptionInfoSection()
        ]
    }

    // MARK: - Services
    
    private lazy var companyInfoNetworkProvider = MainNetworkProvider<AddCompanyService>()
    private lazy var photoNetworkProvider = MainNetworkProvider<PhotosService>()
    private lazy var validator = Validator()
    
    // MARK: - Private variables
    
    private let companyPacket: CompanyPacketType?
    private var sections: [AddCompanyInputSectionModel] = []
    
    // MARK: - Public variables
    
    var initCompany: CompanyEntity?
    var selectedCategory: InterestCategories
    var selectedPhoto: UIImage
    let moduleMode: AddCompanyDependency.Mode
    
    // MARK: - Configure

    private func configureTitleInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(value: self.initCompany?.title, rowType: .title, mode: self.moduleMode)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_title_label")
    }

    private func configureOwnerInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(value: self.initCompany?.directorFirstName, rowType: .ownerName, mode: self.moduleMode),
            AddCompanyInputRowModel(value: self.initCompany?.directorSecondName, rowType: .ownerSecondName, mode: self.moduleMode),
            AddCompanyInputRowModel(value: self.initCompany?.directorLastName, rowType: .ownerLastName, mode: self.moduleMode)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_owner_info_label")
    }

    private func configureLocationInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(value: self.initCompany?.address, rowType: .address, mode: self.moduleMode)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_location_info_label")
    }

    private func configureContactsInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [
//            AddCompanyInputRowModel(value: self.initCompany?.contactsPhone, rowType: .phone),
            AddCompanyInputRowModel(value: "+375 (29) 377-47-47", rowType: .phone, mode: self.moduleMode),
            AddCompanyInputRowModel(value: self.initCompany?.contactsVK, rowType: .vkLink, mode: self.moduleMode),
            AddCompanyInputRowModel(value: self.initCompany?.contactsWebSite, rowType: .webSite, mode: self.moduleMode)
        ]

        return AddCompanyInputSectionModel(rows: rows, title: "ui_company_contacts_info_label")
    }

    private func configureDescriptionInfoSection() -> AddCompanyInputSectionModel {

        let rows: [AddCompanyInputRowModel] = [

            AddCompanyInputRowModel(value: self.initCompany?.descriptionText, rowType: .descriptionInfo, mode: self.moduleMode)
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
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            self?.sendOrganizationInfo(success: success,
                                       failure: failure)
        }
    }
    
    // MARK: - Private
    
    private func sendOrganizationInfo(success: (() -> Void)?,
                                      failure: ((String) -> Void)?) {
        
        guard let token = AccountManager.shared.currentToken else {
            
            failure?("ui_error_title".localized)
            return
        }
        
        var requestModel = CompanyEntity()
        
        for section in self.sections {
            
            for row in section.rows {
                
                switch row.rowType {
                
                case .title:
                    
                    if let string = row.value,
                       self.validator.onlyLetters(string) {
                     
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
                
                case .address:
                    
                    if let string = row.value {
                        
                        requestModel.address = string
                    }
                    else {
                        
                        failure?(self.validationError(.address))
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
        
        requestModel.availableTasksCount = self.companyPacket?.tasksCount ?? 0
        requestModel.availableCouponsCount = self.companyPacket?.benefitsCount ?? 0
        requestModel.availableStocksCount = self.companyPacket?.stocksCount ?? 0
        
        requestModel.latitude = self.companyLatitude
        requestModel.longitude = self.companyLongitude
        
        requestModel.categoryId = self.selectedCategory.rawValue
        
        self.sendPhoto(success: { [weak self] photoId in
            
            requestModel.photoId = Int(photoId) ?? 0
            
            var target: AddCompanyService
            
            guard let mode = self?.moduleMode else { return }
            
            switch mode {
            case .create:
                target = .addCompany(token: token, companyEntity: requestModel)
                
            case .modify:
                target = .modifyCompany(token: token, companyEntity: requestModel)
                
            case .read:
                return
            }
            
            _ = self?.companyInfoNetworkProvider
                .request(target,
                         type: DefaultResponseEntity.self,
                         completion: { result in
                            
                            if result.isSuccess {
                                success?()
                            } else {
                                failure?("ui_error_title".localized)
                            }
                         },
                         failure: { _ in
                            
                            failure?("ui_error_title".localized)
                         })
        }, failure: { message in
            
            failure?(message)
        })
    }

    private func sendPhoto(success: ((String) -> Void)?,
                           failure: ((String) -> Void)?) {
        
        _ = self.photoNetworkProvider.request(.uploadPhoto(self.selectedPhoto),
                                              type: PhotoResponseEntity.self,
                                              completion: { entity in
                                                
                                                if entity.isSuccess {
                                                    
                                                    success?(entity.message)
                                                }
                                                else {
                                                    
                                                    failure?(entity.message)
                                                }
                                              },
                                              failure: { err in
                                                
                                                failure?(err?.localizedDescription ?? "ui_error_title".localized)
                                              })
    }
    
    private func validationError(_ rowType: AddCompanyInputRowModelType) -> String {
        
        return "\(rowType.title.localized) \("ui_validation_faild".localized)"
    }
}
