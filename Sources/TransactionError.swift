//
//  TransactionError.swift
//  Transactions
//
//  Created by Anton Bronnikov on 27/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

public enum TransactionError : Error {

    /// Trying to begin a transaction while the previous one is still active.
    case anotherTransactionIsStillActive

    /// Tryting to commit/rollback a transaction while it was not began yet.
    case transactionIsNotActive

    /// Trying to commit a transaction while one of its transactables is in inconsistent state.
    case uncommittable

    /// Trying to commit/rollback with a wrong transaction descriptor.
    case wrongTransactionDescriptor

}
