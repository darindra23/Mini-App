//
//  TargetType.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

public enum HTTPMethod {
    case post
    case get
    case update
    case delete

    public var rawValue: String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        case .update:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

public protocol TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethod { get }

    /// The type of HTTP task to be performed.
    var task: Task { get }
}
