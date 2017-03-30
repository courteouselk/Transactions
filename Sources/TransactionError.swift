//
//  TransactionError.swift
//  Transactions
//
//  Created by Anton Bronnikov on 27/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

/// Transaction management related error.

public enum TransactionError : Error {

    /// Failed to begin a transaction because another transaction is still active.
    case anotherTransactionIsStillActive

    /// Failed to commit or rollback a transaction because no transaction was actually running.
    case transactionIsNotActive

    /// Failed to commit a transaction because some transactable in its context reported inconsistency.
    case uncommittableTransaction

    /// Trying to commit/rollback a transaction with a wrong transaction descriptor.
    case wrongTransactionDescriptor

}
