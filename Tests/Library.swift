//
//  TransactionTests+Library.swift
//  Transactions
//
//  Created by Anton Bronnikov on 25/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import Transactions

final class Library : Transactable, CustomStringConvertible {

    let name: String

    private var _transactionContext: TransactionContext? = nil

    private var _committabilityError: Error? = nil

    var transactionContext: TransactionContext {
        return _transactionContext!
    }

    var description: String {
        return "Library \"\(name)\""
    }

    private (set) var beginCount = 0
    private (set) var commitCount = 0
    private (set) var rollbackCount = 0

    init(name: String) {
        self.name = name

        _transactionContext = TransactionContext.createRoot(owner: self)
    }

    func hasCommittabilityError() -> Error? {
        return _committabilityError
    }

    func onBegin(transaction: Transaction) {
        beginCount += 1
    }

    func onCommit(transaction: Transaction) {
        commitCount += 1
    }

    func onRollback(transaction: Transaction) {
        rollbackCount += 1
    }

    func resetCounts() {
        beginCount = 0
        commitCount = 0
        rollbackCount = 0
    }

    func setCommittabilityError(_ error: Error) {
        _committabilityError = error
    }

}
