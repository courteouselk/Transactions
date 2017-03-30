//
//  WeakWrapper.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import Foundation

struct WeakWrapper<O: AnyObject> : Equatable, Hashable {

    static func hashValue(_ object: O) -> Int {
        // Better alternative for Unmanaged.passUnretained(object).toOpaque().hashValue
        return ObjectIdentifier(object).hashValue
    }

    static func == (lhs: WeakWrapper, rhs: WeakWrapper) -> Bool {
        // WeakWrapper reference wrappers are only equal if the instances they wrap are the same.
        return lhs.object === rhs.object
    }

    let hashValue: Int

    private (set) public weak var object: O? = nil

    init(_ object: O) {
        self.object = object
        self.hashValue = WeakWrapper.hashValue(object)
    }
    
}
