//
//  ActiveTransactionContextNodeTests.swift
//  Transactions
//
//  Created by Anton Bronnikov on 28/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class ActiveTransactionContextNodeTests : ActiveTransactionContextTests {

    // MARK: - Begin transaction

    func test_BeginTransaction_Throws() {
        XCTAssertThrowsError(try self.bookA.beginTransaction()) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.anotherTransactionIsActive)
        }
    }

    // MARK: - Commit transaction

    func test_CommitTransaction_WithWildcardDescriptor_DoesNotThrow() {
        do {
            try bookB.commitTransaction()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_Throws() {
        library.setCommittabilityError(LibraryError.someError)

        XCTAssertThrowsError(try self.bookA.commitTransaction()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_DoesNotTriggerTransactable() {
        library.setCommittabilityError(LibraryError.someError)

        do { try bookB.commitTransaction(noncurrentTransaction) } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    func test_CommitTransaction_WithCurrentDescriptor_DoesNotThrow() {
        do {
            try bookA.commitTransaction(currentTransaction)
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_Throws() {
        library.setCommittabilityError(LibraryError.someError)

        XCTAssertThrowsError(try self.bookB.commitTransaction(currentTransaction)) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_DoesNotTriggerTransactable() {
        library.setCommittabilityError(LibraryError.someError)

        do { try bookA.commitTransaction(currentTransaction) } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 1)

        XCTAssertEqual(library.failedValidationsCount, 1)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    func test_CommitTransaction_WithNoncurrentDescriptor_Throws() {
        XCTAssertThrowsError(try self.bookB.commitTransaction(noncurrentTransaction)) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.wrongTransactionDescriptor)
        }
    }

    func test_CommitTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable() {
        do { try bookA.commitTransaction(noncurrentTransaction) } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    // MARK: -

    func test_CommitTransaction_WithWildcardDescriptor_SetsContextStateInactive() {
        try! bookA.commitTransaction()

        XCTAssertFalse(library.transactionIsActive)
        XCTAssertFalse(bookA.transactionIsActive)
        XCTAssertFalse(bookB.transactionIsActive)
    }

    func test_CommitTransaction_WithWildcardDescriptor_SetsContextTransactionNil() {
        try! bookA.commitTransaction()

        XCTAssertNil(library.transactionContext.activeTransaction)
        XCTAssertNil(bookA.transactionContext.activeTransaction)
        XCTAssertNil(bookB.transactionContext.activeTransaction)
    }

    func test_CommitTransaction_WithWildcardDescriptor_TriggersTransactablesOnCommitOnly() {
        try! bookA.commitTransaction()

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 1)
        XCTAssertEqual(bookA.validationsCount, 1)
        XCTAssertEqual(bookB.validationsCount, 1)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 1)
        XCTAssertEqual(bookA.commitCount, 1)
        XCTAssertEqual(bookB.commitCount, 1)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    // MARK: -

    func test_CommitTransaction_WithCurrentDescriptor_SetsContextStateInactive() {
        try! bookA.commitTransaction(currentTransaction)

        XCTAssertFalse(library.transactionIsActive)
        XCTAssertFalse(bookA.transactionIsActive)
        XCTAssertFalse(bookB.transactionIsActive)
    }

    func test_CommitTransaction_WithCurrentDescriptor_SetsContextTransactionNil() {
        try! bookB.commitTransaction(currentTransaction)

        XCTAssertNil(library.transactionContext.activeTransaction)
        XCTAssertNil(bookA.transactionContext.activeTransaction)
        XCTAssertNil(bookB.transactionContext.activeTransaction)
    }

    func test_CommitTransaction_WithCurrentDescriptor_TriggersTransactablesOnCommitOnly() {
        try! bookB.commitTransaction(currentTransaction)

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 1)
        XCTAssertEqual(bookA.validationsCount, 1)
        XCTAssertEqual(bookB.validationsCount, 1)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 1)
        XCTAssertEqual(bookA.commitCount, 1)
        XCTAssertEqual(bookB.commitCount, 1)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    // MARK: - Rollback transaction

    func test_RollbackTransaction_WithWildcardDescriptor_DoesNotThrow() {
        do {
            try bookB.rollbackTransaction()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_RollbackTransaction_WithCurrentDescriptor_DoesNotThrow() {
        do {
            try bookA.rollbackTransaction(currentTransaction)
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_RollbackTransaction_WithNoncurrentDescriptor_Throws() {
        XCTAssertThrowsError(try self.bookA.rollbackTransaction(noncurrentTransaction)) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.wrongTransactionDescriptor)
        }
    }

    func test_RollbackTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable() {
        do { try bookB.rollbackTransaction(noncurrentTransaction) } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    // MARK: -

    func test_RollbackTransaction_WithWildcardDescriptor_SetsContextStateInactive() {
        try! bookB.rollbackTransaction()

        XCTAssertFalse(library.transactionIsActive)
        XCTAssertFalse(bookA.transactionIsActive)
        XCTAssertFalse(bookB.transactionIsActive)
    }

    func test_RollbackTransaction_WithWildcardDescriptor_SetsContextTransactionNil() {
        try! bookB.rollbackTransaction()

        XCTAssertNil(library.transactionContext.activeTransaction)
        XCTAssertNil(bookA.transactionContext.activeTransaction)
        XCTAssertNil(bookB.transactionContext.activeTransaction)
    }

    func test_RollbackTransaction_WithWildcardDescriptor_TriggersTransactablesOnRollbackOnly() {
        try! bookB.rollbackTransaction()

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)
    }

    // MARK: -

    func test_RollbackTransaction_WithCurrentDescriptor_SetsContextStateInactive() {
        try! bookA.rollbackTransaction(currentTransaction)

        XCTAssertFalse(library.transactionIsActive)
        XCTAssertFalse(bookA.transactionIsActive)
        XCTAssertFalse(bookB.transactionIsActive)
    }

    func test_RollbackTransaction_WithCurrentDescriptor_SetsContextTransactionNil() {
        try! bookA.rollbackTransaction(currentTransaction)

        XCTAssertNil(library.transactionContext.activeTransaction)
        XCTAssertNil(bookA.transactionContext.activeTransaction)
        XCTAssertNil(bookB.transactionContext.activeTransaction)
    }

    func test_RollbackTransaction_WithCurrentDescriptor_TriggersTransactablesOnRollbackOnly() {
        try! bookA.rollbackTransaction(currentTransaction)

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)
    }

    // MARK: - Transaction closure

    func test_SuccesfulTransactionClosure_DoesNotThrow() {
        do {
            try bookB.doTransactionClosure()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_SuccesfulTransactionClosure_DoesNotChangeTransactionStatus() {
        try! bookA.doTransactionClosure()

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)

        XCTAssertEqual(library.transactionClosureCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 1)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
    }

    func test_SuccesfulNestingTransactionClosures_DoNotThrow() {
        do {
            try bookB.doNestingTranscationClosure()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_SuccesfulNestingTransactionClosures_DoNotChangeTransactionStatus() {
        try! bookA.doNestingTranscationClosure()

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)

        XCTAssertEqual(library.transactionClosureCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 1)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
    }

    // MARK: -

    func test_FailingTransactionClosure_Throws() {
        XCTAssertThrowsError(try self.bookB.doTransactionClosureThatThrows()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_FailingTransactionClosure_DoesNotChangeTransactionStatus() {
        do { try bookA.doTransactionClosureThatThrows() } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)

        XCTAssertEqual(library.transactionClosureCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
    }

    func test_FailingNestingTransactionClosure_Throws() {
        XCTAssertThrowsError(try self.bookB.doNestingTranscationClosureThatThrows()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_FailingNestingTransactionClosure_DoNotChangeTransactionStatus() {
        do { try bookA.doNestingTranscationClosureThatThrows() } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)

        XCTAssertEqual(library.transactionClosureCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
    }

    // MARK: - Add new transaction-context node

    func test_RegisterNode_TriggersOnBegin() {
        let bookD = Book(library: library, name: "Book D")
        let volume1 = Volume(book: bookD, name: "Volume 1")
        let volume2 = Volume(book: bookD, name: "Volume 2")

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)
        XCTAssertEqual(bookD.beginCount, 1)
        XCTAssertEqual(volume1.beginCount, 1)
        XCTAssertEqual(volume2.beginCount, 1)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)
        XCTAssertEqual(bookD.validationsCount, 0)
        XCTAssertEqual(volume1.validationsCount, 0)
        XCTAssertEqual(volume2.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)
        XCTAssertEqual(bookD.failedValidationsCount, 0)
        XCTAssertEqual(volume1.failedValidationsCount, 0)
        XCTAssertEqual(volume2.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)
        XCTAssertEqual(bookD.commitCount, 0)
        XCTAssertEqual(volume1.commitCount, 0)
        XCTAssertEqual(volume2.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
        XCTAssertEqual(bookD.commitCount, 0)
        XCTAssertEqual(volume1.commitCount, 0)
        XCTAssertEqual(volume2.commitCount, 0)

        XCTAssertEqual(library.transactionClosureCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
        XCTAssertEqual(bookD.commitCount, 0)
        XCTAssertEqual(volume1.commitCount, 0)
        XCTAssertEqual(volume2.commitCount, 0)
    }

}
