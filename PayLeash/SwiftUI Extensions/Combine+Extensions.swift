//
//  Combine+Extensions.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 13..
//

import Foundation
import Combine

extension Publisher where Self.Failure == Never {
    /// Assigns the value of a publisher to an object, using a weak reference.
    ///
    /// - Parameter keyPath: The keyPath of the property to which the upstream value will be assigned.
    /// - Parameter object: The object on which the property will be set. The retain count for `object` will not be increased. Using `self` as this parameter will not cause a reference cycle.
    public func weakAssign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable {
        return self.sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
