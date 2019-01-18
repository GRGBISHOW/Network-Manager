//
//  Models.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 6/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import Foundation

struct DataModel<T:Decodable>:Decodable {
    var data:T
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct User: Decodable {
    var id: Int = 0
    var firstName: String? = nil
    var lastName: String? = nil
    var imgUrl: String? = nil
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case imgUrl = "avatar"
    }
}

struct NullResponse:Decodable {}

struct LoginRequest: Encodable {
    var email: String
    var password: String?
}




