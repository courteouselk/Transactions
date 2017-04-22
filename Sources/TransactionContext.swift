//
//  TransactionContext.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

/// Helper class for transaction context management.
///
/// An instanse of `TransactionContext` should be owned by each individual `Transactable`.  There 
/// are two kind of transaction contexts, root and node.  The root instance stands at the root of
/// the contexts tree structure and is typically owned by the top-level container of the
/// transactables hierarchy.  All other transactables own a context node that can have one parent 
/// node and multiple child nodes.
///
/// Any transaction status change (begin/commit/rollback) requested on a context node is dispatched 
/// to the root of the tree, from where the requested action is propagated throughout the whole 
/// hierarchy of contexts.

public class TransactionContext {

    // MARK: - Transaction state

    /// Indicates whether the transaction is currently active.

    final public var transactionIsActive: Bool { return activeTransaction != nil }

    /// Currently active transaction.
    ///
    /// If no transaction is active the value is `nil`.

    public var activeTransaction: Transaction? { mustOverride() }

    // MARK: -

    typealias WrappedContextNode = WeakWrapper<TransactionContextNode>

    unowned let owner: Transactable
    var root: TransactionContextRoot { mustOverride() }
    private var children: Set<WrappedContextNode> = []

    // MARK: - Initialization

    init(owner: Transactable) {
        self.owner = owner
    }

    /// Creates a transaction-context root.
    ///
    /// - parameter owner: `Transactable` instance that will own the context root.

    final public class func createRoot(owner: Transactable) -> TransactionContext {
        return TransactionContextRoot(owner: owner)
    }

    /// Creates a transaction-context node.
    ///
    /// - parameters:
    ///   - owner: `Transactable` instance that will own the context node.
    ///   - parent: An instance of `Transactable` object whose transaction context will be a parent
    ///             of the created one.

    final public class func createNode(owner: Transactable, parent: Transactable) -> TransactionContext {
        return TransactionContextNode(owner: owner, parent: parent)
    }

    // MARK: - Transaction state management

    /// Begin a new transaction.
    ///
    /// - throws: Can throw an instance of `TransactionError` (e.g. if another transaction is 
    ///           already active).
    ///
    /// - returns: The descriptor for a newly started transaction.

    @discardableResult public func beginTransaction() throws -> Transaction {
        mustOverride()
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

    public func commitTransaction(_ transaction: Transaction = Transaction.any) throws {
        mustOverride()
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

    public func rollbackTransaction(_ transaction: Transaction = Transaction.any) throws {
        mustOverride()
    }

    // MARK: -

    final func validateCommit() throws {
        try owner.onValidateCommit()

        try children.forEach({
            try $0.object?.validateCommit()
        })
    }

    final func register(node: TransactionContextNode) {
        let wrappedNode = WrappedContextNode(node)

        assert(!children.contains(wrappedNode))

        children.insert(wrappedNode)
    }

    final func unregister(node: TransactionContextNode) {
        let wrappedNode = WrappedContextNode(node)

        assert(children.contains(wrappedNode))

        children.remove(wrappedNode)
    }

    // MARK: -

    final func propagateTransactionBegin() {
        owner.onBegin(transaction: activeTransaction!)

        for wrappedNode in children {
            guard let node = wrappedNode.object else {
                children.remove(wrappedNode)
                continue
            }

            node.propagateTransactionBegin()
        }
    }

    final func propagateTransactionCommit() {
        for wrappedNode in children {
            guard let node = wrappedNode.object else {
                children.remove(wrappedNode)
                continue
            }

            node.propagateTransactionCommit()
        }

        owner.onCommit(transaction: activeTransaction!)
    }

    final func propagateTransactionRollback() {
        for wrappedNode in children {
            guard let node = wrappedNode.object else {
                children.remove(wrappedNode)
                continue
            }

            node.propagateTransactionRollback()
        }

        owner.onRollback(transaction: activeTransaction!)
    }

}
