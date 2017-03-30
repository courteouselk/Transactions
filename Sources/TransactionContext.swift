//
//  TransactionContext.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

/// Helper class for transaction context management.
///
/// Should be owned by each individual `Transactable`.

public class TransactionContext {

    // MARK: - Transaction status

    /// Currently active transaction.
    ///
    /// If no transaction is active the value is `nil`.

    public var transaction: Transaction? {
        fatalError()
    }

    /// Indicates whether the transaction is currently active.

    final public var isActive: Bool {
        return transaction != nil
    }
    
    // MARK: - Context

    var root: TransactionContextRoot {
        fatalError()
    }

    typealias WrappedContextNode = WeakWrapper<TransactionContextNode>

    private var children: Set<WrappedContextNode> = []
    
    // MARK: - Transactable

    unowned let owner: Transactable

    // MARK: - Initialization

    init(owner: Transactable) {
        self.owner = owner
    }

    /// Creates transaction-context root.
    ///
    /// The root context is used to govern the whole context tree.

    final public class func createRoot(owner: Transactable) -> TransactionContext {
        return TransactionContextRoot(owner: owner)
    }

    /// Creates transaction-context node.

    final public class func createNode(owner: Transactable, parent: Transactable) -> TransactionContext {
        return TransactionContextNode(owner: owner, parent: parent)
    }

    // MARK: - Consistency propagation

    /// Indicates whether all transactables enclosed in the current context's scope (`self`) are in
    /// committable state.

    final func isCommittable() -> Bool {
        return owner.isCommittable()
            && !children.contains(where: { !($0.object?.isCommittable() ?? true) })
    }
    
    // MARK: - Transaction management

    /// Requests the transaction start.
    ///
    /// - throws: In the case of an exception an instance of `TransactionError` is thrown.
    ///
    /// - returns: The descriptor for a newly started transaction.

    @discardableResult public func beginTransaction() throws -> Transaction {
        fatalError()
    }

    /// Requests the transaction commit.
    ///
    /// - throws: In the case of an exception an instance of `TransactionError` is thrown.
    ///
    /// - parameter transaction: The descriptor of the transaction to commit.

    public func commitTransaction(_ transaction: Transaction = Transaction.any) throws {
        fatalError()
    }

    /// Requests the transaction rollback.
    ///
    /// - throws: In the case of an exception an instance of `TransactionError` is thrown.
    ///
    /// - parameter transaction: The descriptor of the transaction to rollback.

    public func rollbackTransaction(_ transaction: Transaction = Transaction.any) throws {
        fatalError()
    }

    // MARK: - Context management

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

    // MARK: - Transaction state propagation

    final func propagateTransactionBegin() {
        owner.onBegin(transaction: transaction!)

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

        owner.onCommit(transaction: transaction!)
    }

    final func propagateTransactionRollback() {
        for wrappedNode in children {
            guard let node = wrappedNode.object else {
                children.remove(wrappedNode)
                continue
            }

            node.propagateTransactionRollback()
        }

        owner.onRollback(transaction: transaction!)
    }

}
