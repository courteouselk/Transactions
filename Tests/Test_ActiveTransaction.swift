//
//  Test_ActiveTransaction.swift
//  Transactions
//
//  Created by Anton Bronnikov on 27/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class Test_ActiveTransaction: XCTestCase {

    final var library: Library! = nil
    final var bookA: Book! = nil
    final var bookB: Book! = nil
    final var bookC: Book? = nil

    final var noncurrentTransaction: Transaction! = nil
    final var currentTransaction: Transaction! = nil

    final override func setUp() {
        library = Library(name: "Main")
        bookA = Book(library: library, name: "Design Patterns")
        bookB = Book(library: library, name: "Algorithms")
        bookC = Book(library: library, name: "Marketing")
        bookC = nil

        noncurrentTransaction = try! library.beginTransaction()
        try! library.rollbackTransaction()
        currentTransaction = try! library.beginTransaction()

        library.resetCounts()
        bookA.resetCounts()
        bookB.resetCounts()
    }

    final override func tearDown() {
        library = nil
        bookA = nil
        bookB = nil

        noncurrentTransaction = nil
        currentTransaction = nil
    }

    // MARK: - Verify initial state

    final func test_InitialState_ObjectStructureIsValid() {
        XCTAssertNotNil(library)
        XCTAssertNotNil(bookA)
        XCTAssertNotNil(bookB)
        XCTAssertNil(bookC)
    }

    final func test_InitialState_CountersAreZero() {
        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(library.rollbackCount, 0)

        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)

        XCTAssertEqual(bookB.beginCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    final func test_InitialState_ContextsAreActive() {
        XCTAssertTrue(library.transactionIsActive)
        XCTAssertTrue(bookA.transactionIsActive)
        XCTAssertTrue(bookB.transactionIsActive)
    }

    final func test_InitialState_ContextTransactionsAreNotNil() {
        XCTAssertEqual(library.transactionContext.transaction, currentTransaction)
        XCTAssertEqual(bookA.transactionContext.transaction, currentTransaction)
        XCTAssertEqual(bookB.transactionContext.transaction, currentTransaction)
    }

}
