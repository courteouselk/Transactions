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
    override var activeTransaction: Transaction? { return _transaction }
    override var root: TransactionContextRoot { return self }

    // MARK: - Transaction management

    override func beginTransaction() throws -> Transaction {
        guard !transactionIsActive else {
            throw TransactionError.anotherTransactionIsActive
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

        guard transactionIsActive else {
            throw TransactionError.transactionIsNotActive
        }

        try validateCommit()

        propagateTransactionCommit()

        _transaction = nil
    }

    override func rollbackTransaction(_ transaction: Transaction) throws {
        guard transaction == Transaction.any || transaction == _transaction else {
            throw TransactionError.wrongTransactionDescriptor
        }

        guard transactionIsActive else {
            throw TransactionError.transactionIsNotActive
        }

        propagateTransactionRollback()

        _transaction = nil
    }

}
