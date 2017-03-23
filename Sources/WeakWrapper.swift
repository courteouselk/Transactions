//
//  WeakWrapper.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import Foundation

public struct WeakWrapper<O: AnyObject> : Equatable, Hashable {

    /// Returns hash value for an object based on its address.
    ///
    /// - parameter object: An object instance to wrap.
    ///
    /// - returns: Hash value.
    public static func hashValue(_ object: O) -> Int {
        // Better alternative for Unmanaged.passUnretained(object).toOpaque().hashValue
        return ObjectIdentifier(object).hashValue
    }

    public static func == (lhs: WeakWrapper, rhs: WeakWrapper) -> Bool {
        // WeakWrapper reference wrappers are only equal if the instances they wrap are the same.
        return lhs.object === rhs.object
    }

    public let hashValue: Int

    private (set) public weak var object: O? = nil

    /// Creates a new weak reference wrapper.
    ///
    /// - parameter object: An object instance to wrap.
    public init(_ object: O) {
        self.object = object
        self.hashValue = WeakWrapper.hashValue(object)
    }
    
}
