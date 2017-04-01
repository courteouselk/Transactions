//
//  Transaction.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import Foundation

/// Transaction descriptor.

public struct Transaction : Equatable {

    // MARK: - Static members

    /// Wildcard transaction descriptor.
    ///
    /// Passed as a default parameter to `.commitTransaction(_)` and `.rollbackTransaction(_)`
    /// methods.

    public static let any = Transaction(id: UUID.zero)

    // MARK: - Instance members

    /// Unique transaction id.

    public let id: UUID

    private init(id: UUID) {
        self.id = id
    }

    init() {
        var id = UUID()

        while id == UUID.zero {
            id = UUID()
        }

        self.id = id
    }

    // MARK: - Equatable

    public static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
    }

}
