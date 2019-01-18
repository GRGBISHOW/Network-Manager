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
    case notConnectedToInternet
    case timeOut
    case cancelled
    case badUrl
    case networkConnectionLost
    case networkResourceUnavailable
    case apiError(apiMessage: String)
    case cannotParseJsonError
    case noMobileDataAvailable //return 410 status code
    case sixtyAttemptsExceededInOneMinute
}

extension NetworkError: LocalizedError  {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("invalid_url", comment: "Invalid url")
        case .notConnectedToInternet :
            return NSLocalizedString("noConnection_error", comment: "No Internet")
        case .timeOut :
            return NSLocalizedString("timeOut_error", comment: "Request timed out")
        case .cancelled :
            return NSLocalizedString("requestCancelled_error", comment: "Request cancelled")
        case .badUrl :
            return NSLocalizedString("badUrl_error", comment: "Invalid url")
        case .networkConnectionLost :
            return NSLocalizedString("connectionLost_error", comment: "Connection lost")
        case .networkResourceUnavailable :
            return NSLocalizedString("networkResource_error", comment: "Resource unavailable")
        case .apiError (let msg) :
            return NSLocalizedString(msg, comment: "Error unknown")
        case .cannotParseJsonError :
            return NSLocalizedString("Cannot parse JSON", comment: "No Internet")
        case .noMobileDataAvailable :
            return NSLocalizedString("noConnection_error", comment: "No Internet")
        case .sixtyAttemptsExceededInOneMinute :
            return NSLocalizedString("You have exceeded your limit of 60 requests in one minute", comment: "No Internet")
        }
    }
}
