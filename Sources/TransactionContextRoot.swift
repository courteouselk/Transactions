//
//  TransactionContextRoot.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import Foundation

final class TransactionContextRoot : TransactionContext {

    private var _transaction: Transaction? = nil

    override var transaction: Transaction? {
        return _transaction
    }

    override var root: TransactionContextRoot {
        return self
    }

    // MARK: - Transaction management

    override func beginTransaction() throws -> Transaction {
        guard !isActive else {
            throw TransactionError.anotherTransactionIsStillActive
        }

        let newTransaction = Transaction()

        _transaction = newTransaction

        propagateTransactionBegin()

        return newTransaction
    }

    override func commitTransaction(_ transaction: Transaction) throws {
        guard transaction == Transaction.any || transaction == _transaction else {
            throw TransactionError.wrongTransactionDescriptor
        }

        guard isActive else {
            throw TransactionError.transactionIsNotActive
        }

        guard isCommittable() else {
            throw TransactionError.uncommittableTransaction
        }

        propagateTransactionCommit()

        _transaction = nil
    }

    override func rollbackTransaction(_ transaction: Transaction) throws {
        guard transaction == Transaction.any || transaction == _transaction else {
            throw TransactionError.wrongTransactionDescriptor
        }

        guard isActive else {
            throw TransactionError.transactionIsNotActive
        }

        propagateTransactionRollback()

        _transaction = nil
    }

}
