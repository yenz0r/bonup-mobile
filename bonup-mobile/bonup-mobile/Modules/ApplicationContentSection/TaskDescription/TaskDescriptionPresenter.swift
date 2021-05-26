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
    var qrCodeImage: UIImage? { get }
}

final class TaskDescriptionPresenter {

    private weak var view: ITaskDescriptionView?
    private let interactor: ITaskDescriptionInteractor
    private let router: ITaskDescriptionRouter
    private let currentTask: TaskListCurrentTasksEntity

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
        return Double(self.currentTask.x)
    }

    var longitude: Double {
        return Double(self.currentTask.y)
    }

    var qrCodeImage: UIImage? {
        guard let userToken = AccountManager.shared.currentToken else { return nil }
        let taskId = self.currentTask.id
        let qrLine = "\(taskId)-\(userToken)"

        return QRcodeManager.shared.createQRFromString(str: qrLine)
    }

    var title: String {
        return self.currentTask.name
    }

    var description: String {
        return self.currentTask.description
    }

    var imageURL: URL? {
        return URL(string: self.currentTask.photos.first ?? "")
    }

    var organizationTitle: String {
        return self.currentTask.organizationName
    }

    var fromDate: String {
        return self.currentTask.dateFrom
    }

    var toDate: String {
        return self.currentTask.dateTo
    }

    var categoryTitle: String {
        return "#\(self.currentTask.category)\(self.currentTask.subcategory)"
    }

    var balls: String {
        return "+\(self.currentTask.ballCount)"
    }
}