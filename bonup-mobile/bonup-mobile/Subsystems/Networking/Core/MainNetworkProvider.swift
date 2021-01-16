//
//  MainNetworkProvider.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import Moya

protocol IMainTargetType: TargetType {
    
}

protocol IMainNetworkProvider {

    associatedtype MainTarget: IMainTargetType

    func request<T: Decodable>(_ target: MainTarget,
                               type: T.Type,
                               completion: @escaping (T) -> Void,
                               failure: ((MoyaError?) -> Void)?) -> Cancellable

    func requestString(_ target: MainTarget,
                       completion: @escaping (String) -> Void,
                       failure: ((MoyaError?) -> Void)?) -> Cancellable

    func requestBool(_ target: MainTarget,
                     completion: @escaping (Bool) -> Void,
                     failure: ((MoyaError?) -> Void)?) -> Cancellable

}

class MainNetworkProvider<MainTarget: IMainTargetType> {

    // MARK: - Internal variables

    let moyaProvider: MoyaProvider<MainTarget>

    // MARK: - Initialization

    init() {
        
        moyaProvider = MoyaProvider<MainTarget>()
    }
}

// MARK: - IMainServiceProvider

extension MainNetworkProvider: IMainNetworkProvider {

    private func isSessionOutdated(_ code: Int) -> Bool {

        if (code == 400) {

            let user = AccountManager.shared.currentUser
            AppRouter.shared.present(.login(name: user?.name, email: user?.email))
            AccountManager.shared.currentUser = nil
            return true
        }

        return false
    }

    @discardableResult
    func request<T: Decodable>(_ target: MainTarget,
                               type: T.Type,
                               completion: @escaping (T) -> Void,
                               failure: ((MoyaError?) -> Void)?) -> Cancellable {

        UIApplication.topViewController()?.view.endEditing(true)
        AlertsFactory.shared.loadingAlert(.show(message: "ui_wait_a_bit_please".localized))

        return moyaProvider.request(target) { result in

            AlertsFactory.shared.loadingAlert(.hide)

            switch result {

            case let .success(response):

                do {

//                    if (self.isSessionOutdated(response.statusCode)) {
//                        return;
//                    }

                    let data = try JSONDecoder().decode(T.self,
                                                        from: response.data)
                    completion(data)
                } catch {

                    failure?(nil)

                }

            case let .failure(error):

                failure?(error)

            }
        }
    }

    func requestSignal(_ target: MainTarget) -> Cancellable {
        return moyaProvider.request(target, completion: { _ in })
    }

    func requestBool(_ target: MainTarget,
                     completion: @escaping (Bool) -> Void,
                     failure: ((MoyaError?) -> Void)?) -> Cancellable {

        AlertsFactory.shared.loadingAlert(.show(message: "ui_wait_a_bit_please".localized))

        return moyaProvider.request(target) { result in

            AlertsFactory.shared.loadingAlert(.hide)

            switch result {

            case let .success(response):

                do {

//                    if (self.isSessionOutdated(response.statusCode)) {
//                        return;
//                    }

                    let string = String(data: response.data, encoding: .utf8)

                    guard let unwrapped = string else {

                        failure?(nil)

                        return
                    }

                    let bool = NSString(string: unwrapped).boolValue

                    completion(bool)
                }

            case let .failure(error):

                failure?(error)

            }
        }
    }

    func requestImage(_ target: MainTarget,
                      completion: @escaping (UIImage?) -> Void,
                      failure: ((MoyaError?) -> Void)?) -> Cancellable {

        AlertsFactory.shared.loadingAlert(.show(message: "ui_wait_a_bit_please".localized))

        return moyaProvider.request(target) { result in

            AlertsFactory.shared.loadingAlert(.hide)

            switch result {

            case let .success(response):

                do {

                    completion(UIImage(data: response.data))
                }

            case let .failure(error):

                failure?(error)

            }
        }
    }


    func requestString(_ target: MainTarget,
                       completion: @escaping (String) -> Void,
                       failure: ((MoyaError?) -> Void)?) -> Cancellable {

        AlertsFactory.shared.loadingAlert(.show(message: "ui_wait_a_bit_please".localized))

        return moyaProvider.request(target) { result in

            AlertsFactory.shared.loadingAlert(.hide)

            switch result {

            case let .success(response):

                do {

//                    if (self.isSessionOutdated(response.statusCode)) {
//                        return;
//                    }

                    let string = String(data: response.data, encoding: .utf8)

                    guard let unwrapped = string else {

                        if let unwrapped = failure {

                            unwrapped(nil)

                        } else {

                            failure?(nil)

                        }
                        return
                    }

                    let replaced = unwrapped.replacingOccurrences(of: "\\\"", with: "\"")
                    completion(replaced)
                }

            case let .failure(error):

                failure?(error)

            }
        }
    }
}
