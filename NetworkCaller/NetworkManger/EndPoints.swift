//
//  EndPoints.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 6/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import Foundation
enum API {}

extension API {
    /*Name Space */ enum Auth {
        static func login(name:String, password:String) -> Endpoint<UserProfile> {
            return Endpoint(
                method: .post,
                path: "auth/authenticate",
                parameters: ["username" : name, "password": password]
            )
        }
    }
    
    enum ThirdParty {
        static func getDateTimeData() -> Endpoint<DateTimeModel> {
            return Endpoint(path: AppUrl.ThirdParty.jsonTest, parser: ParserType.thirdParty)
        }
    }
   
}
