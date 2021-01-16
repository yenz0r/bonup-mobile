//
//  SettingsService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import Moya

enum SettingsService {

    case uploadAvatar(UIImage)
    case getAvatar(String)
}

extension SettingsService: IAuthorizedTargetType {

    var baseURL: URL {
        return URL(string: serverBase)!
    }

    var path: String {

        switch self {
        case .uploadAvatar(_):
            return "/uploadAvatar"
        case .getAvatar(_):
            return "/getAvatar"
        }
    }

    var method: Moya.Method {
        switch self {
        case .uploadAvatar(_):
            return .post
        case .getAvatar(_):
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {

        case .getAvatar(let token):
            return .requestParameters(
                parameters: [
                    "token": token
                ],
                encoding: JSONEncoding.default
            )

        case .uploadAvatar(let image):
            let imageData = image.jpegData(compressionQuality: 1.0)
            let memberIdData = "---".data(using: String.Encoding.utf8) ?? Data()
            var formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(imageData!), name: "user_img", fileName: "user.jpeg", mimeType: "image/jpeg")]
            formData.append(Moya.MultipartFormData(provider: .data(memberIdData), name: "member_id"))
            return .uploadMultipart(formData)
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
