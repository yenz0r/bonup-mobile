//
//  SettingsService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import Moya

enum PhotosService {

    case uploadPhoto(UIImage)
    case getPhoto(String)
    
    static func photoURL(for id: Int?) -> URL? {
        
        guard let id = id else { return nil }
        
        let api = serverBase + "/photo"
        let urlStr = api + "/\(id)"
        
        return URL(string: urlStr)
    }
}

extension PhotosService: IAuthorizedTargetType {

    var baseURL: URL {
        return URL(string: serverBase)!
    }

    var path: String {

        switch self {
        case .uploadPhoto(_):
            return "/photo"
        case .getPhoto(_):
            return "/photo"
        }
    }

    var method: Moya.Method {
        switch self {
        case .uploadPhoto(_):
            return .post
        case .getPhoto(_):
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {

        case .getPhoto(let token):
            return .requestParameters(
                parameters: [
                    "token": token
                ],
                encoding: JSONEncoding.default
            )

        case .uploadPhoto(let image):
            
            let imageData = image.pngData()
            let formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(imageData!),
                                                                             name: "file",
                                                                             fileName: "file.png",
                                                                             mimeType: "image/png")]
            return .uploadMultipart(formData)
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
