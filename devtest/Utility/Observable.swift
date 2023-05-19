//
//  Observable.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

public final class Observable<T> {
    public typealias Listener = (T) -> Void
    var listener: Listener?

    public func bind(_ listener: Listener?) {
        self.listener = listener
    }

    public func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    public var value: T {
        didSet {
            listener?(value)
        }
    }

    public init(_ v: T) {
        value = v
    }
}
