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

    init(view: ITaskDescriptionView?,
         interactor: ITaskDescriptionInteractor,
         router: ITaskDescriptionRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskDescriptionPresenter implementation

extension TaskDescriptionPresenter: ITaskDescriptionPresenter {
    var latitude: Double {
        return 59.952
    }

    var longitude: Double {
        return 30.318
    }

    var qrCodeImage: UIImage? {
        return QRcodeManager.shared.createQRFromString(str: "test-line")
    }

    var title: String {
        return "Visit RuCompany"
    }

    var description: String {
        return "You need to visit "
    }

    var imageURL: URL? {
        return URL(string: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg")
    }

    var organizationTitle: String {
        return "RuCompany"
    }

    var fromDate: String {
        return "05.10.2020"
    }

    var toDate: String {
        return "10.10.2020"
    }

    var categoryTitle: String {
        return "#coffesporthealthylifestyle"
    }

    var balls: String {
        return "+300"
    }
}
