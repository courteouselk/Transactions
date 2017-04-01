//
//  TransactionError.swift
//  Transactions
//
//  Created by Anton Bronnikov on 27/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

/// Transaction related error.

public enum TransactionError : Error {

    /// Failed to begin a new transaction because another transaction is active.
    case anotherTransactionIsActive

    /// Failed to commit/rollback a transaction because no transaction is actually active.
    case transactionIsNotActive

    /// Trying to commit/rollback a transaction using wrong transaction descriptor.
    case wrongTransactionDescriptor

}
