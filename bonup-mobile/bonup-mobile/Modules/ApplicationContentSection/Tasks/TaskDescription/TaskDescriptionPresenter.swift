//
//  TaskDescriptionPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 06.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ITaskDescriptionPresenter: AnyObject {
    var title: String { get }
    var description: String { get }
    var imageURL: URL? { get }
    var organizationTitle: String { get }
    var fromDate: String { get }
    var toDate: String { get }
    var categoryTitle: String { get }
    var balls: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var qrCode: String { get }
    var director: String { get }
    var address: String { get }
    
    func handlePhoneTap()
    func handleWebSiteTap()
    func handleVkLinkTap()
    
    func handleDetailsTap()
}

final class TaskDescriptionPresenter {

    // MARK: - Private variables
    
    private weak var view: ITaskDescriptionView?
    private let interactor: ITaskDescriptionInteractor
    private let router: ITaskDescriptionRouter
    
    // MARK: - Data variables
    
    private let currentTask: TaskListCurrentTasksEntity

    // MARK: - Init
    
    init(view: ITaskDescriptionView?,
         interactor: ITaskDescriptionInteractor,
         router: ITaskDescriptionRouter,
         currentTask: TaskListCurrentTasksEntity) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.currentTask = currentTask
    }
}

// MARK: - ITaskDescriptionPresenter implementation

extension TaskDescriptionPresenter: ITaskDescriptionPresenter {
    var latitude: Double {
        return Double(self.currentTask.organization.latitude)
    }

    var longitude: Double {
        return Double(self.currentTask.organization.longitude)
    }

    var qrCode: String {
        
        guard let userToken = AccountManager.shared.currentToken else { return "" }
        let taskId = self.currentTask.id
        let qrLine = "\(taskId)+\(userToken)"

        return qrLine
    }

    var title: String {
        return self.currentTask.name
    }

    var description: String {
        return self.currentTask.description
    }

    var imageURL: URL? {
        return PhotosService.photoURL(for: self.currentTask.photoId)
    }

    var organizationTitle: String {
        return self.currentTask.organization.title
    }

    var fromDate: String {
        return self.currentTask.dateFrom
    }

    var toDate: String {
        return self.currentTask.dateTo
    }

    var categoryTitle: String {
        return "\(InterestCategories.category(id: self.currentTask.categoryId).title)"
    }

    var balls: String {
        return "+\(self.currentTask.bonusesCount)"
    }
    
    var director: String {
        
        return self.currentTask.organization.directorFirstName + " " +
               self.currentTask.organization.directorSecondName + " " +
               self.currentTask.organization.directorLastName
    }
    
    var address: String {
        
        return self.currentTask.organization.address
    }
    
    func handleDetailsTap() {
        
        self.router.show(.showCompanyDetails(company: self.currentTask.organization))
    }
    
    func handlePhoneTap() {
        
        var openURL: URL
        
        let validator = Validator()
        if let url = URL(string: "tel://" + self.currentTask
                            .organization
                            .contactsPhone.filter { validator.onlyNumbers(String($0)) }) {
            
            openURL = url
        }
        else {
            
            openURL = URL(string: "https://google.com")!
        }
        
        self.router.show(.openURL(openURL))
    }
    
    func handleWebSiteTap() {
        
        var openURL: URL
        
        if let url = URL(string: self.currentTask.organization.contactsWebSite) {
            
            openURL = url
        }
        else {
            
            openURL = URL(string: "https://google.com")!
        }
        
        self.router.show(.openURL(openURL))
    }
    
    func handleVkLinkTap() {
        
        var openURL: URL
        
        if let url = URL(string: self.currentTask.organization.contactsVK) {
            
            openURL = url
        }
        else {
            
            openURL = URL(string: "https://google.com")!
        }
        
        self.router.show(.openURL(openURL))
    }
}
