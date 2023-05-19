//
//  NetworkError.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case decodeFailed(modelName: String, description: String)
    case requestFailed
    case pageNotFound
    case underMaintenance
    case timeout

    var title: String {
        switch self {
        case let .decodeFailed(modelName, _):
            return "\(modelName) Decode Failed"
        case .requestFailed:
            return "No Internet"
        case .pageNotFound:
            return "Page Not Found"
        case .underMaintenance:
            return "Under Maintenance"
        case .timeout:
            return "Time Out"
        }
    }

    var message: String {
        switch self {
        case let .decodeFailed(_, desription):
            return desription
        case .requestFailed:
            return "Make sure you’re connected to internet."
        case .pageNotFound:
            return "Oops, I think you're going the wrong direction."
        case .underMaintenance:
            return "We’re cleaning the house so your experience will be smoother than ever. Please try again later."
        case .timeout:
            return "Please check your internet connection and try again."
        }
    }
}

extension DecodingError.Context {
    var errorLog: String {
        var desc = debugDescription
        if let codingKey = codingPath.first {
            desc = desc + #" Key: "\#(codingKey.stringValue)""#
        }
        return desc
    }
}
