//
//  Models.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 6/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import Foundation

class ResponseStatus: Decodable {
    var code: String?
    var message: String?
    var codeText: String?
    var responseTimeStamp: String?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case codeText = "code_text"
        case message
        case responseTimeStamp = "response_timestamp"
    }
}

class BaseResponse<T:Decodable>:Decodable {
    var status: ResponseStatus?
    var body: T?
    
    private enum CodingKeys: String, CodingKey {
        case status
        case body
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(ResponseStatus.self, forKey: .status)
        body  = try container.decodeIfPresent(T.self, forKey: .body)
    }
}


struct UserProfile: Decodable {
     var id: Int = 0
     var firstName: String? = nil
     var lastName: String? = nil
     var middleName: String? = nil
     var email: String? = nil
     var imgUrl: String? = nil
     var thumbUrl: String? = nil
     var role: String? = nil

    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
        case email = "email"
        case imgUrl = "image_url"
        case thumbUrl = "thumb_url"
        case role
    }
}



struct DateTimeModel: Decodable {
    var time:String?
    var date:String?
    
    enum CodingKeys: String, CodingKey {
        case time
        case date
    }
}



