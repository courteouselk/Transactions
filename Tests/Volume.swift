//
//  Volume.swift
//  Transactions
//
//  Created by Anton Bronnikov on 26/04/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import Transactions

final class Volume : Transactable, CustomStringConvertible {

    // MARK: - Instance properties

    unowned let book: Book

    let name: String

    private var _transactionContext: TransactionContext? = nil
    var transactionContext: TransactionContext { return _transactionContext! }

    private var _committabilityError: Error? = nil

    var description: String { return "Book \"\(name)\"" }

    private (set) var beginCount = 0
    private (set) var commitCount = 0
    private (set) var rollbackCount = 0
    private (set) var transactionClosureCount = 0

    // MARK: - Initializers

    init(book: Book, name: String) {
        self.book = book
        self.name = name

        _transactionContext = TransactionContext.createNode(owner: self, parent: book)
    }

    // MARK: - Transactable

    func onBegin(transaction: Transaction) {
        beginCount += 1
    }

    func onValidateCommit() throws {
        if let error = _committabilityError {
            throw error
        }
    }

    func onCommit(transaction: Transaction) {
        commitCount += 1
    }

    func onRollback(transaction: Transaction) {
        rollbackCount += 1
    }

    // MARK: -

    func resetCounts() {
        beginCount = 0
        commitCount = 0
        rollbackCount = 0
        transactionClosureCount = 0
    }

    func setCommittabilityError(_ error: Error) {
        _committabilityError = error
    }

    // MARK: -

    func doTransactionClosure() throws {
        try transaction {
            transactionClosureCount += 1
        }
    }

    func doNestingTranscationClosure() throws {
        try transaction {
            try doTransactionClosure()
        }
    }

    func doTransactionClosureThatThrows() throws {
        try transaction {
            throw LibraryError.someError
        }
    }

    func doNestingTranscationClosureThatThrows() throws {
        try transaction {
            try doTransactionClosureThatThrows()
        }
    }

}
