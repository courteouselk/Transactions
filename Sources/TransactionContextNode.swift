//
//  TransactionContextNode.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import Foundation

final class TransactionContextNode : TransactionContext {

    override var transaction: Transaction? {
        return root.transaction
    }

    private unowned let _root: TransactionContextRoot

    override var root: TransactionContextRoot {
        return _root
    }

    // MARK: - Initialization

    init(owner: Transactable, parent: Transactable) {
        _root = parent.transactionContext.root

        super.init(owner: owner)

        parent.transactionContext.register(node: self)
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
