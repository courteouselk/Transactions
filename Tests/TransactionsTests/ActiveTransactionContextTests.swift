//
//  ActiveTransactionContextTests.swift
//  Transactions
//
//  Created by Anton Bronnikov on 27/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class ActiveTransactionContextTests: TransactionContextTests {

    final var noncurrentTransaction: Transaction! = nil
    final var currentTransaction: Transaction! = nil

    final override func setUp() {
        super.setUp()

        noncurrentTransaction = try! library.beginTransaction()
        try! library.rollbackTransaction()
        currentTransaction = try! library.beginTransaction()

        library.resetCounts()
        bookA.resetCounts()
        bookB.resetCounts()
    }

    final override func tearDown() {
        noncurrentTransaction = nil
        currentTransaction = nil

        super.tearDown()
    }

    // MARK: - Verify initial state

    final func test_InitialState_ContextsAreActive() {
        XCTAssertTrue(library.transactionIsActive)
        XCTAssertTrue(bookA.transactionIsActive)
        XCTAssertTrue(bookB.transactionIsActive)
    }

    final func test_InitialState_ContextTransactionsAreNotNil() {
        XCTAssertEqual(library.activeTransaction, currentTransaction)
        XCTAssertEqual(bookA.activeTransaction, currentTransaction)
        XCTAssertEqual(bookB.activeTransaction, currentTransaction)
    }

}
