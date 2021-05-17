//
//  CompanyPacketPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyPacketPresenter: AnyObject {

    var packets: [CompanyPacketType] { get }
    var selectedPacket: CompanyPacketType { get }
    var selectedPacketIndex: Int { get }

    func handlePacketSelection(at index: Int)
    
    func handleDoneAction()
}

final class CompanyPacketPresenter {

    // MARK: - Private variables

    private weak var view: ICompanyPacketView?
    private let interactor: ICompanyPacketInteractor
    private let router: ICompanyPacketRouter

    // MARK: - Init

    init(view: ICompanyPacketView?, interactor: ICompanyPacketInteractor, router: ICompanyPacketRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICompanyPacketPresenter

extension CompanyPacketPresenter: ICompanyPacketPresenter {

    var packets: [CompanyPacketType] {

        return self.interactor.packets
    }

    func handlePacketSelection(at index: Int) {

        switch self.packets[index] {

        case .junior:
            fallthrough
        case .middle:
            fallthrough
        case .senior:
            self.interactor.selectedPacket = self.interactor.packets[index]
            return

        case .custom(_, _, _):
            self.interactor.selectedPacket = self.interactor.packets[index]
            self.view?.updateBlurState(active: true)
            self.router.show(.customPacket) { [weak self] newPacket in

                self?.interactor.updateCustomPacket(newPacket)
                self?.view?.reloadItem(at: newPacket.id)
                self?.view?.updateBlurState(active: false)
            }

        case .none:
            return
        }
    }
    
    func handleDoneAction() {
    
        if let tasksCount = self.interactor.selectedPacket.tasksCount,
           let couponsCount = self.interactor.selectedPacket.benefitsCount {
        
            self.router.show(.addCompany(packet: self.interactor.selectedPacket),
                             completion: nil)
        }
        else {
         
            self.router.show(.showAlert(text: "ui_incorrect_company_packet_info".localized),
                             completion: nil)
        }
    }

    var selectedPacket: CompanyPacketType {

        return self.interactor.selectedPacket
    }

    var selectedPacketIndex: Int {

        return self.packets.firstIndex { $0.id == self.selectedPacket.id } ?? 0
    }
}
