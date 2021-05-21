//
//  CompanyPacketInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyPacketInteractor: AnyObject {

    var packets: [CompanyPacketType] { get }

    var selectedPacket: CompanyPacketType { get set }

    func updateCustomPacket(_ packet: CompanyPacketType)
}

final class CompanyPacketInteractor {

    // MARK: - Initialization

    init() {

        self._packets = CompanyPacketType.allCases
        self._selectedPacket = .none
    }

    // MARK: - Private variables

    private var _packets: [CompanyPacketType]
    private var _selectedPacket: CompanyPacketType
}

// MARK: - ICompanyPacketInteractor implementation

extension CompanyPacketInteractor: ICompanyPacketInteractor {
    var selectedPacket: CompanyPacketType {

        get {

            return self._selectedPacket
        }
        
        set {

            if (self._selectedPacket.id != newValue.id) {

                self._selectedPacket = newValue
            }
            else {

                self._selectedPacket = .none
            }
        }
    }


    var packets: [CompanyPacketType] {

        return self._packets
    }

    func updateCustomPacket(_ packet: CompanyPacketType) {

        self._packets.removeLast()
        self._packets.append(packet)
    }
}
