//
//  Transactable.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

/// Transaction-aware object.
///
/// Conforming object change their state as a part of transaction.  Each individual transaction 
/// will encapsulate changes to all of the objects and only commit if all of them report
/// consistency.

public protocol Transactable : AnyObject {

    /// Transaction context owned by a transactable.

    var transactionContext: TransactionContext { get }

    /// Indicates whether a transactable is in committable (i.e. consistent) state.

    func isCommittable() -> Bool

    // MARK: - Transaction management

    /// Transaction begin handler.
    /// 
    /// This method is called at the beginning of each transaction to allow the transactable object
    /// make necessary preparations before the transaction starts.

    func onBegin(transaction: Transaction)

    /// Transaction commit handler.
    ///
    /// This method is called when the transaction commit is requested.

    func onCommit(transaction: Transaction)

    /// Transaction rollback handler.
    ///
    /// This method is called when the transaction rollback is requested.

    func onRollback(transaction: Transaction)
    
}

// MARK: - Default implementations

extension Transactable {

    /// Indicates whether the transaction is currently active.

    public var transactionIsActive: Bool {
        return transactionContext.isActive
    }

    /// Currently active transaction.
    ///
    /// If no transaction is active the value is `nil`.

    public var activeTransaction: Transaction? {
        return transactionContext.transaction
    }

    /// Requests the transaction start.
    ///
    /// - throws: In the case of an exception an instance of `TransactionError` is thrown.
    ///
    /// - returns: The descriptor for a newly started transaction.

    @discardableResult public func beginTransaction() throws -> Transaction {
        return try transactionContext.beginTransaction()
    }

    /// Requests the transaction commit.
    ///
    /// - throws: In the case of an exception an instance of `TransactionError` is thrown.
    ///
    /// - parameter transaction: The descriptor of the transaction to commit.

    public func commitTransaction(_ transaction: Transaction = Transaction.any) throws {
        try transactionContext.commitTransaction(transaction)
    }

    /// Requests the transaction rollback.
    ///
    /// - throws: In the case of an exception an instance of `TransactionError` is thrown.
    ///
    /// - parameter transaction: The descriptor of the transaction to rollback.

    public func rollbackTransaction(_ transaction: Transaction = Transaction.any) throws {
        try transactionContext.rollbackTransaction(transaction)
    }

}
