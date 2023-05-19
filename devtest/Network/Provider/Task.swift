//
//  Task.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

/// Represents an HTTP task.
public enum Task {
    /// A request with no additional data.
    case requestPlain

    /// A requests body set with data.
    case requestData([String: Any])
}
