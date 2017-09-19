//
//  WeakWrapper.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import Foundation

struct WeakWrapper<Object: AnyObject> : Equatable, Hashable {

    let hashValue: Int

    private (set) weak var object: Object? = nil

    init(_ object: Object) {
        self.object = object
        self.hashValue = ObjectIdentifier(object).hashValue
    }
    
    static func == (lhs: WeakWrapper, rhs: WeakWrapper) -> Bool {
        return lhs.object === rhs.object
    }

}
