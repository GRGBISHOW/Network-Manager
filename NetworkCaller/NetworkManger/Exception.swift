//
//  Parser.swift
//  NetworkCaller
//
//  Created by Gurung Bishow on 10/7/18.
//  Copyright © 2018 Gurung Bishow. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    // Add other Error Types to handle Exception
}

extension NetworkError: LocalizedError  {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("invalid_url", comment: "Invalid url")
        }
    }
}
