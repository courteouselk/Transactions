//
//  Test_InactiveTransaction.swift
//  Transactions
//
//  Created by Anton Bronnikov on 24/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class Test_InactiveTransaction : XCTestCase {

    final var library: Library! = nil
    final var bookA: Book! = nil
    final var bookB: Book! = nil
    final var bookC: Book? = nil

    final override func setUp() {
        library = Library(name: "Main")
        bookA = Book(library: library, name: "Design Patterns")
        bookB = Book(library: library, name: "Algorithms")
        bookC = Book(library: library, name: "Marketing")
        bookC = nil
    }

    final override func tearDown() {
        library = nil
        bookA = nil
        bookB = nil
        bookC = nil
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

    final func test_InitialState_ContextsAreInactive() {
        XCTAssertFalse(library.transactionIsActive)
        XCTAssertFalse(bookA.transactionIsActive)
        XCTAssertFalse(bookB.transactionIsActive)
    }

    final func test_InitialState_ContextTransactionsAreNil() {
        XCTAssertNil(library.transactionContext.transaction)
        XCTAssertNil(bookA.transactionContext.transaction)
        XCTAssertNil(bookB.transactionContext.transaction)
    }

    final func test_InitialState_TransactablesAreCommittable() {
        XCTAssertNil(library.hasCommittabilityError())
        XCTAssertNil(bookA.hasCommittabilityError())
        XCTAssertNil(bookB.hasCommittabilityError())
    }

}
