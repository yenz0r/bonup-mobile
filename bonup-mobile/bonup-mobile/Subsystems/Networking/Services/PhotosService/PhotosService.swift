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
    case getPhotoId(String)
    
    static func photoURL(for id: Int?) -> URL? {
        
        guard let id = id else { return nil }
        
        let api = SERVER_BASE_URL + "/photo"
        let urlStr = api + "/\(id)"
        
        return URL(string: urlStr)
    }
    
    static func photoPath(for id: Int?) -> String {
        
        guard let id = id else { return "" }
        
        let api = SERVER_BASE_URL + "/photo"
        return api + "/\(id)"
    }
}

extension PhotosService: IAuthorizedTargetType {

    var baseURL: URL {
        return URL(string: SERVER_BASE_URL)!
    }

    var path: String {

        switch self {
        case .uploadPhoto(_):
            return "/photo"
        case .getPhotoId(_):
            return "/photo"
        }
    }

    var method: Moya.Method {
        switch self {
        case .uploadPhoto(_):
            return .post
        case .getPhotoId(_):
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {

        case .getPhotoId(let token):
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
