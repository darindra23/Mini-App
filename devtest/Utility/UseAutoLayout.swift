//
//  UseAutoLayout.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import UIKit

@propertyWrapper
public struct UseAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
