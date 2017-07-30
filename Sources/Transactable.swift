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

    /// Call-back method for transaction begin.
    /// 
    /// This method is called at the beginning of each transaction to allow the transactable object
    /// to make all necessary preparations before the transaction starts.

    func onBegin(transaction: Transaction)

    /// Call-back method that verifies whether a transaction is good to commit the changes.
    ///
    /// This method is called by the context prior transaction commit.  If no one of the 
    /// transactables in the context tree throws an error, the commit can proceed.
    ///
    /// - throws: An error is thrown in case if the transaction can not be commited.

    func onValidateCommit() throws

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

public extension Transactable {

    // MARK: Protocol extensions

    /// Indicates whether the transaction is currently active.
    ///
    /// - important: This property is not supposed to be implemented by the adopting class.
    ///              Please use the default implementation.

    public var transactionIsActive: Bool { return transactionContext.transactionIsActive }

    /// Currently active transaction.
    ///
    /// If no transaction is active the value is `nil`.
    ///
    /// - important: This property is not supposed to be implemented by the adopting class.
    ///              Please use the default implementation.

    public var activeTransaction: Transaction? { return transactionContext.activeTransaction }

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

    /// Syntactical sugar used to enclose transactions in the methods defined on `Transactable` 
    /// object.
    ///
    /// The execution sequence is:
    /// 
    /// 1. Call `beginTransaction()` method.
    /// 2. Call argument closure `executeTransaction()`.
    /// 3. If `executeTransaction()` does not throw any errors, call `commitTransaction()`.
    ///    Otherwise, call `rollbackTransaction()` and rethrow any error that
    ///    `executeTransaction()` might have thrown.
    ///
    /// **Example:**
    /// ````
    /// func doSomething() {
    ///     try transaction {
    ///         // your code here
    ///     }
    /// }
    /// ````
    ///
    /// - note: It is possible to nest `transaction` blocks.  If a nesting method already had
    ///         started the transaction then nested method will apply updates as part of that 
    ///         transaction.
    ///
    /// - parameters:
    ///   - transactionBody: Closure that encapsulated the body of the transaction.
    ///
    /// - throws: Any error that `executeTransaction`, `beginTransaction`, `commitTransaction`, or
    ///           `rollbackTransaction` might throw.

    public func doTransactionally<Result>(_ transactionBody: () throws -> Result) throws -> Result {
        if transactionContext.transactionIsActive {
            return try transactionBody()
        } else {
            try transactionContext.beginTransaction()

            let result: Result

            do {
                result = try transactionBody()
                try transactionContext.commitTransaction()
            }
            catch {
                try transactionContext.rollbackTransaction()
                throw error
            }

            return result
        }
    }

}
