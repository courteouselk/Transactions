//
//  TransactionContextNode.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import Foundation

final class TransactionContextNode : TransactionContext {

    override var activeTransaction: Transaction? { return root.activeTransaction }
    private unowned let _root: TransactionContextRoot
    override var root: TransactionContextRoot { return _root }

    // MARK: - Initialization

    init(owner: Transactable, parent: Transactable) {
        let parentTransactionContext = parent.transactionContext

        _root = parentTransactionContext.root

        super.init(owner: owner)

        parentTransactionContext.register(node: self)

        if parentTransactionContext.transactionIsActive {
            propagateTransactionBegin()
        }
    }

    // MARK: - Transaction management

    override func beginTransaction() throws -> Transaction {
        return try root.beginTransaction()
    }

    override func commitTransaction(_ transaction: Transaction) throws {
        try root.commitTransaction(transaction)
    }

    override func rollbackTransaction(_ transaction: Transaction) throws {
        try root.rollbackTransaction(transaction)
    }

}
