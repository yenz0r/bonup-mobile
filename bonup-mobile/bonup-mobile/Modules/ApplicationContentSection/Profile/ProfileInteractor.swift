//
//  ProfileInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 20.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IProfileInteractor: AnyObject {
}

final class ProfileInteractor {

    private let networkProvider = MainNetworkProvider<NewPasswordService>()

}

// MARK: - IChangePasswordInteractor implementation

extension ProfileInteractor: IProfileInteractor {


}
