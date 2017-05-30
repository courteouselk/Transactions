//
//  TransactionContextTests.swift
//  Transactions
//
//  Created by Anton Bronnikov on 22/04/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class TransactionContextTests : XCTestCase {

    final var library: Library! = nil
    final var bookA: Book! = nil
    final var bookB: Book! = nil
    final var bookC: Book? = nil

    override func setUp() {
        library = Library(name: "Library")
        bookA = Book(library: library, name: "Book A")
        bookB = Book(library: library, name: "Book B")
        bookC = Book(library: library, name: "Book C")
        bookC = nil
    }

    override func tearDown() {
        library = nil
        bookA = nil
        bookB = nil
        bookC = nil
    }

    // MARK: - Verify initial state

    func test_InitialState_ObjectStructureIsValid() {
        XCTAssertNotNil(library)
        XCTAssertNotNil(bookA)
        XCTAssertNotNil(bookB)
        XCTAssertNil(bookC)
    }

    func test_InitialState_CountersAreZero() {
        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(library.transactionClosureCount, 0)

        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 0)

        XCTAssertEqual(bookB.beginCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
    }

}
