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
    var name: String? = nil
    var year: Int = 0
    var color: String? = nil
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case year
        case color
    }
}

struct NullResponse:Decodable {}

struct LoginRequest: Encodable {
    var email: String
    var password: String?
}




