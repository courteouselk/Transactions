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
/// will encapsulate changes to all of the objects in transaction context tree and only commit if 
/// all of them report no consistency errors.

public protocol Transactable : AnyObject {

    // MARK: Protocol requirements

    /// Transaction context owned by a transactable.

    var transactionContext: TransactionContext { get }

    /// Verifies committability of the transactable.
    ///
    /// - returns: This method returns `nil` if everything is Ok and the transactable is good to 
    ///            commit the changes.  Otherwise an error describing the problem is returned.  This
    ///            error will be thrown by `TransactionContext`'s `.commitTransaction()` method.

    func hasCommittabilityError() -> Error?

    /// Call-back method for transaction begin.
    /// 
    /// This method is called at the beginning of each transaction to allow the transactable object
    /// to make all necessary preparations before the transaction starts.

    func onBegin(transaction: Transaction)

    /// Call-back method for transaction commit.
    ///
    /// This method is called when the transaction commit is requested.  The transactable should 
    /// incorporate all staged changes into an active state.

    func onCommit(transaction: Transaction)

    /// Call-back method for transaction rollback.
    ///
    /// This method is called when the transaction is being rolled back.  The transactable should
    /// discard any staged changes and reset its state.

    func onRollback(transaction: Transaction)
    
}

extension Transactable {

    // MARK: Default implementations

    /// Indicates whether the transaction is currently active.
    ///
    /// - important: This property is not supposed to be implemented by the adopting class.
    ///              Please use the default implementation.

    public var transactionIsActive: Bool {
        return transactionContext.isActive
    }

    /// Currently active transaction.
    ///
    /// If no transaction is active the value is `nil`.
    ///
    /// - important: This property is not supposed to be implemented by the adopting class.
    ///              Please use the default implementation.

    public var activeTransaction: Transaction? {
        return transactionContext.transaction
    }

    /// Begin a new transaction.
    ///
    /// - throws: Can throw an instance of `TransactionError` (e.g. if another transaction is
    ///           already active).
    ///
    /// - returns: The descriptor for a newly started transaction.
    ///
    /// - important: This method is not supposed to be implemented by the adopting class.
    ///              Please use the default implementation.

    @discardableResult public func beginTransaction() throws -> Transaction {
        return try transactionContext.beginTransaction()
    }

    /// Commit the transaction.
    ///
    /// - throws: Can throw an instance of `TransactionError` (e.g. if no transaction is actually
    ///           active) or whatever `Error` returned by one of the transactable
    ///           `.hasCommittabilityError()` methods.
    ///
    /// - parameters:
    ///   - transaction: The descriptor of the transaction to commit.  If this parameter is
    ///                  not omitted then the context will check whether it matches to the
    ///                  actually active one.  If they do not match, an error is thrown.
    ///
    /// - important: This method is not supposed to be implemented by the adopting class.
    ///              Please use the default implementation.

    public func commitTransaction(_ transaction: Transaction = Transaction.any) throws {
        try transactionContext.commitTransaction(transaction)
    }

    /// Rollback the transaction.
    ///
    /// - throws: Can throw an instance of `TransactionError` (e.g. if no transaction is actually
    ///           active).
    ///
    /// - parameters:
    ///   - transaction: The descriptor of the transaction to rollback.  If this parameter is
    ///                  not omitted then the context will check whether it matches to the
    ///                  actually active one.  If they do not match, an error is thrown.
    ///
    /// - important: This method is not supposed to be implemented by the adopting class.
    ///              Please use the default implementation.

    public func rollbackTransaction(_ transaction: Transaction = Transaction.any) throws {
        try transactionContext.rollbackTransaction(transaction)
    }

}
