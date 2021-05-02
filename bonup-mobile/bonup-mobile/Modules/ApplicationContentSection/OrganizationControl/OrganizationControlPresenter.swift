//
//  OrganizationControlPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import SwiftQRScanner

protocol IOrganizationControlPresenter: AnyObject {

    func numberOfControls() -> Int
    func title(for index: Int) -> String
    func icon(for index: Int) -> UIImage?
    
    func handleActionSelection(at index: Int)
}

final class OrganizationControlPresenter {

    private weak var view: IOrganizationControlView?
    private let interactor: IOrganizationControlInteractor
    private let router: IOrganizationControlRouter

    private let actions: [OrganizationControlAction] = [.verifyTask,
                                                        .varifyCoupon,
                                                        .addTask,
                                                        .addCoupon,
                                                        .statistics]
    
    private var currentAction: OrganizationControlAction?

    init(view: IOrganizationControlView?,
         interactor: IOrganizationControlInteractor,
         router: IOrganizationControlRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IOrganizationControlPresenter implementation

extension OrganizationControlPresenter: IOrganizationControlPresenter {

    func numberOfControls() -> Int {

        return self.actions.count
    }

    func title(for index: Int) -> String {

        return self.actions[index].title
    }

    func icon(for index: Int) -> UIImage? {

        return self.actions[index].icon
    }

    func handleActionSelection(at index: Int) {

        let action = self.actions[index]
        
        switch action {
        case .verifyTask:
            fallthrough
        case .varifyCoupon:
            self.currentAction = action
            self.router.show(.verifyAction(self))
            
        case .addTask:
            self.router.show(.showAddAction(.task, self.interactor.organizationName))
            
        case .addCoupon:
            self.router.show(.showAddAction(.coupon, self.interactor.organizationName))
            
        case .statistics:
            self.router.show(.showStatistics(self.interactor.organizationName))
        }
    }
}

// MARK: - QRScannerCodeDelegate

extension OrganizationControlPresenter: QRScannerCodeDelegate {

    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {

        guard let action = self.currentAction else {
            
            self.view?.dismissPresentedScanner()
            return
        }
        
        switch action {
        
        case .verifyTask:
            self.interactor.resolveTask(qrCode: result, block: { [weak self] isSuccess, message in
                
                self?.router.show(.showResultAlert(message))
            })
            
        case .varifyCoupon:
            self.interactor.activateCoupon(qrCode: result, block: { [weak self] isSuccess, message in
                
                self?.router.show(.showResultAlert(message))
            })
            
        default:
            break
        }
        
        self.currentAction = nil
        self.view?.dismissPresentedScanner()
    }

    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }

    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}
