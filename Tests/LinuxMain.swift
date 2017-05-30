// Generated using Sourcery 0.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

//  Copyright © 2017 Anton Bronnikov. All rights reserved.

import XCTest
import TransactionsTests

extension ActiveTransactionContextNodeTests {

    static var allTests = [
        ("test_BeginTransaction_Throws", test_BeginTransaction_Throws),
        ("test_CommitTransaction_WithWildcardDescriptor_DoesNotThrow", test_CommitTransaction_WithWildcardDescriptor_DoesNotThrow),
        ("test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_Throws", test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_Throws),
        ("test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_DoesNotTriggerTransactable", test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_DoesNotTriggerTransactable),
        ("test_CommitTransaction_WithCurrentDescriptor_DoesNotThrow", test_CommitTransaction_WithCurrentDescriptor_DoesNotThrow),
        ("test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_Throws", test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_Throws),
        ("test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_DoesNotTriggerTransactable", test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_DoesNotTriggerTransactable),
        ("test_CommitTransaction_WithNoncurrentDescriptor_Throws", test_CommitTransaction_WithNoncurrentDescriptor_Throws),
        ("test_CommitTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable", test_CommitTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable),
        ("test_CommitTransaction_WithWildcardDescriptor_SetsContextStateInactive", test_CommitTransaction_WithWildcardDescriptor_SetsContextStateInactive),
        ("test_CommitTransaction_WithWildcardDescriptor_SetsContextTransactionNil", test_CommitTransaction_WithWildcardDescriptor_SetsContextTransactionNil),
        ("test_CommitTransaction_WithWildcardDescriptor_TriggersTransactablesOnCommitOnly", test_CommitTransaction_WithWildcardDescriptor_TriggersTransactablesOnCommitOnly),
        ("test_CommitTransaction_WithCurrentDescriptor_SetsContextStateInactive", test_CommitTransaction_WithCurrentDescriptor_SetsContextStateInactive),
        ("test_CommitTransaction_WithCurrentDescriptor_SetsContextTransactionNil", test_CommitTransaction_WithCurrentDescriptor_SetsContextTransactionNil),
        ("test_CommitTransaction_WithCurrentDescriptor_TriggersTransactablesOnCommitOnly", test_CommitTransaction_WithCurrentDescriptor_TriggersTransactablesOnCommitOnly),
        ("test_RollbackTransaction_WithWildcardDescriptor_DoesNotThrow", test_RollbackTransaction_WithWildcardDescriptor_DoesNotThrow),
        ("test_RollbackTransaction_WithCurrentDescriptor_DoesNotThrow", test_RollbackTransaction_WithCurrentDescriptor_DoesNotThrow),
        ("test_RollbackTransaction_WithNoncurrentDescriptor_Throws", test_RollbackTransaction_WithNoncurrentDescriptor_Throws),
        ("test_RollbackTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable", test_RollbackTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable),
        ("test_RollbackTransaction_WithWildcardDescriptor_SetsContextStateInactive", test_RollbackTransaction_WithWildcardDescriptor_SetsContextStateInactive),
        ("test_RollbackTransaction_WithWildcardDescriptor_SetsContextTransactionNil", test_RollbackTransaction_WithWildcardDescriptor_SetsContextTransactionNil),
        ("test_RollbackTransaction_WithWildcardDescriptor_TriggersTransactablesOnRollbackOnly", test_RollbackTransaction_WithWildcardDescriptor_TriggersTransactablesOnRollbackOnly),
        ("test_RollbackTransaction_WithCurrentDescriptor_SetsContextStateInactive", test_RollbackTransaction_WithCurrentDescriptor_SetsContextStateInactive),
        ("test_RollbackTransaction_WithCurrentDescriptor_SetsContextTransactionNil", test_RollbackTransaction_WithCurrentDescriptor_SetsContextTransactionNil),
        ("test_RollbackTransaction_WithCurrentDescriptor_TriggersTransactablesOnRollbackOnly", test_RollbackTransaction_WithCurrentDescriptor_TriggersTransactablesOnRollbackOnly),
        ("test_SuccesfulTransactionClosure_DoesNotThrow", test_SuccesfulTransactionClosure_DoesNotThrow),
        ("test_SuccesfulTransactionClosure_DoesNotChangeTransactionStatus", test_SuccesfulTransactionClosure_DoesNotChangeTransactionStatus),
        ("test_SuccesfulNestingTransactionClosures_DoNotThrow", test_SuccesfulNestingTransactionClosures_DoNotThrow),
        ("test_SuccesfulNestingTransactionClosures_DoNotChangeTransactionStatus", test_SuccesfulNestingTransactionClosures_DoNotChangeTransactionStatus),
        ("test_FailingTransactionClosure_Throws", test_FailingTransactionClosure_Throws),
        ("test_FailingTransactionClosure_DoesNotChangeTransactionStatus", test_FailingTransactionClosure_DoesNotChangeTransactionStatus),
        ("test_FailingNestingTransactionClosure_Throws", test_FailingNestingTransactionClosure_Throws),
        ("test_FailingNestingTransactionClosure_DoNotChangeTransactionStatus", test_FailingNestingTransactionClosure_DoNotChangeTransactionStatus),
        ("test_RegisterNode_TriggersOnBegin", test_RegisterNode_TriggersOnBegin),
    ]

}

// MARK: -

extension ActiveTransactionContextRootTests {

    static var allTests = [
        ("test_BeginTransaction_Throws", test_BeginTransaction_Throws),
        ("test_CommitTransaction_WithWildcardDescriptor_DoesNotThrow", test_CommitTransaction_WithWildcardDescriptor_DoesNotThrow),
        ("test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_Throws", test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_Throws),
        ("test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_DoesNotTriggerTransactable", test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_DoesNotTriggerTransactable),
        ("test_CommitTransaction_WithCurrentDescriptor_DoesNotThrow", test_CommitTransaction_WithCurrentDescriptor_DoesNotThrow),
        ("test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_Throws", test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_Throws),
        ("test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_DoesNotTriggerTransactable", test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_DoesNotTriggerTransactable),
        ("test_CommitTransaction_WithNoncurrentDescriptor_Throws", test_CommitTransaction_WithNoncurrentDescriptor_Throws),
        ("test_CommitTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable", test_CommitTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable),
        ("test_CommitTransaction_WithWildcardDescriptor_SetsContextStateInactive", test_CommitTransaction_WithWildcardDescriptor_SetsContextStateInactive),
        ("test_CommitTransaction_WithWildcardDescriptor_SetsContextTransactionNil", test_CommitTransaction_WithWildcardDescriptor_SetsContextTransactionNil),
        ("test_CommitTransaction_WithWildcardDescriptor_TriggersTransactablesOnCommitOnly", test_CommitTransaction_WithWildcardDescriptor_TriggersTransactablesOnCommitOnly),
        ("test_CommitTransaction_WithCurrentDescriptor_SetsContextStateInactive", test_CommitTransaction_WithCurrentDescriptor_SetsContextStateInactive),
        ("test_CommitTransaction_WithCurrentDescriptor_SetsContextTransactionNil", test_CommitTransaction_WithCurrentDescriptor_SetsContextTransactionNil),
        ("test_CommitTransaction_WithCurrentDescriptor_TriggersTransactablesOnCommitOnly", test_CommitTransaction_WithCurrentDescriptor_TriggersTransactablesOnCommitOnly),
        ("test_RollbackTransaction_WithWildcardDescriptor_DoesNotThrow", test_RollbackTransaction_WithWildcardDescriptor_DoesNotThrow),
        ("test_RollbackTransaction_WithCurrentDescriptor_DoesNotThrow", test_RollbackTransaction_WithCurrentDescriptor_DoesNotThrow),
        ("test_RollbackTransaction_WithNoncurrentDescriptor_Throws", test_RollbackTransaction_WithNoncurrentDescriptor_Throws),
        ("test_RollbackTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable", test_RollbackTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable),
        ("test_RollbackTransaction_WithWildcardDescriptor_SetsContextStateInactive", test_RollbackTransaction_WithWildcardDescriptor_SetsContextStateInactive),
        ("test_RollbackTransaction_WithWildcardDescriptor_SetsContextTransactionNil", test_RollbackTransaction_WithWildcardDescriptor_SetsContextTransactionNil),
        ("test_RollbackTransaction_WithWildcardDescriptor_TriggersTransactablesOnRollbackOnly", test_RollbackTransaction_WithWildcardDescriptor_TriggersTransactablesOnRollbackOnly),
        ("test_RollbackTransaction_WithCurrentDescriptor_SetsContextStateInactive", test_RollbackTransaction_WithCurrentDescriptor_SetsContextStateInactive),
        ("test_RollbackTransaction_WithCurrentDescriptor_SetsContextTransactionNil", test_RollbackTransaction_WithCurrentDescriptor_SetsContextTransactionNil),
        ("test_RollbackTransaction_WithCurrentDescriptor_TriggersTransactablesOnRollbackOnly", test_RollbackTransaction_WithCurrentDescriptor_TriggersTransactablesOnRollbackOnly),
        ("test_SuccesfulTransactionClosure_DoesNotThrow", test_SuccesfulTransactionClosure_DoesNotThrow),
        ("test_SuccesfulTransactionClosure_DoesNotChangeTransactionStatus", test_SuccesfulTransactionClosure_DoesNotChangeTransactionStatus),
        ("test_SuccesfulNestingTransactionClosures_DoNotThrow", test_SuccesfulNestingTransactionClosures_DoNotThrow),
        ("test_SuccesfulNestingTransactionClosures_DoNotChangeTransactionStatus", test_SuccesfulNestingTransactionClosures_DoNotChangeTransactionStatus),
        ("test_FailingTransactionClosure_Throws", test_FailingTransactionClosure_Throws),
        ("test_FailingTransactionClosure_DoesNotChangeTransactionStatus", test_FailingTransactionClosure_DoesNotChangeTransactionStatus),
        ("test_FailingNestingTransactionClosure_Throws", test_FailingNestingTransactionClosure_Throws),
        ("test_FailingNestingTransactionClosure_DoNotChangeTransactionStatus", test_FailingNestingTransactionClosure_DoNotChangeTransactionStatus),
    ]

}

// MARK: -

extension ActiveTransactionContextTests {

    static var allTests = [
        ("test_InitialState_ContextsAreActive", test_InitialState_ContextsAreActive),
        ("test_InitialState_ContextTransactionsAreNotNil", test_InitialState_ContextTransactionsAreNotNil),
    ]

}

// MARK: -

extension InactiveTransactionContextNodeTests {

    static var allTests = [
        ("test_BeginTransaction_DoesNotThrow", test_BeginTransaction_DoesNotThrow),
        ("test_BeginTransaction_SetsContextStateActive", test_BeginTransaction_SetsContextStateActive),
        ("test_BeginTransaction_SetsContextTransactionConsistently", test_BeginTransaction_SetsContextTransactionConsistently),
        ("test_BeginTransaction_TriggersTransactablesOnBeginOnly", test_BeginTransaction_TriggersTransactablesOnBeginOnly),
        ("test_CommitTransaction_Throws", test_CommitTransaction_Throws),
        ("test_CommitTransaction_DoesNotTriggerTransactable", test_CommitTransaction_DoesNotTriggerTransactable),
        ("test_RollbackTransaction_Throws", test_RollbackTransaction_Throws),
        ("test_RollbackTransaction_DoesNotTriggerTransactable", test_RollbackTransaction_DoesNotTriggerTransactable),
        ("test_SuccesfulTransactionClosure_DoesNotThrow", test_SuccesfulTransactionClosure_DoesNotThrow),
        ("test_SuccesfulTransactionClosure_BeginsAndCommitsTransaction", test_SuccesfulTransactionClosure_BeginsAndCommitsTransaction),
        ("test_SuccesfulNestingTransactionClosures_DoNotThrow", test_SuccesfulNestingTransactionClosures_DoNotThrow),
        ("test_SuccesfulNestingTransactionClosures_BeginAndCommitTransaction", test_SuccesfulNestingTransactionClosures_BeginAndCommitTransaction),
        ("test_FailingTransactionClosure_Throws", test_FailingTransactionClosure_Throws),
        ("test_FailingTransactionClosure_BeginsAndRollsbackTransaction", test_FailingTransactionClosure_BeginsAndRollsbackTransaction),
        ("test_FailingNestingTransactionClosure_Throws", test_FailingNestingTransactionClosure_Throws),
        ("test_FailingNestingTransactionClosure_BeginsAndRollsbackTransaction", test_FailingNestingTransactionClosure_BeginsAndRollsbackTransaction),
        ("test_InvalidatedTransactionClosure_Throws", test_InvalidatedTransactionClosure_Throws),
        ("test_InvalidatedTransactionClosure_BeginsAndRollsbackTransaction", test_InvalidatedTransactionClosure_BeginsAndRollsbackTransaction),
        ("test_InvalidatedNestingTransactionClosure_Throws", test_InvalidatedNestingTransactionClosure_Throws),
        ("test_InvalidatedNestingTransactionClosure_BeginsAndRollsbackTransaction", test_InvalidatedNestingTransactionClosure_BeginsAndRollsbackTransaction),
    ]

}

// MARK: -

extension InactiveTransactionContextRootTests {

    static var allTests = [
        ("test_BeginTransaction_DoesNotThrow", test_BeginTransaction_DoesNotThrow),
        ("test_BeginTransaction_SetsContextStateActive", test_BeginTransaction_SetsContextStateActive),
        ("test_BeginTransaction_SetsContextTransactionConsistently", test_BeginTransaction_SetsContextTransactionConsistently),
        ("test_BeginTransaction_TriggersTransactablesOnBeginOnly", test_BeginTransaction_TriggersTransactablesOnBeginOnly),
        ("test_CommitTransaction_Throws", test_CommitTransaction_Throws),
        ("test_CommitTransaction_DoesNotTriggerTransactable", test_CommitTransaction_DoesNotTriggerTransactable),
        ("test_RollbackTransaction_Throws", test_RollbackTransaction_Throws),
        ("test_RollbackTransaction_DoesNotTriggerTransactable", test_RollbackTransaction_DoesNotTriggerTransactable),
        ("test_SuccesfulTransactionClosure_DoesNotThrow", test_SuccesfulTransactionClosure_DoesNotThrow),
        ("test_SuccesfulTransactionClosure_BeginsAndCommitsTransaction", test_SuccesfulTransactionClosure_BeginsAndCommitsTransaction),
        ("test_SuccesfulNestingTransactionClosures_DoNotThrow", test_SuccesfulNestingTransactionClosures_DoNotThrow),
        ("test_SuccesfulNestingTransactionClosures_BeginAndCommitTransaction", test_SuccesfulNestingTransactionClosures_BeginAndCommitTransaction),
        ("test_FailingTransactionClosure_Throws", test_FailingTransactionClosure_Throws),
        ("test_FailingTransactionClosure_BeginsAndRollsbackTransaction", test_FailingTransactionClosure_BeginsAndRollsbackTransaction),
        ("test_FailingNestingTransactionClosure_Throws", test_FailingNestingTransactionClosure_Throws),
        ("test_FailingNestingTransactionClosure_BeginsAndRollsbackTransaction", test_FailingNestingTransactionClosure_BeginsAndRollsbackTransaction),
        ("test_InvalidatedTransactionClosure_Throws", test_InvalidatedTransactionClosure_Throws),
        ("test_InvalidatedTransactionClosure_BeginsAndRollsbackTransaction", test_InvalidatedTransactionClosure_BeginsAndRollsbackTransaction),
        ("test_InvalidatedNestingTransactionClosure_Throws", test_InvalidatedNestingTransactionClosure_Throws),
        ("test_InvalidatedNestingTransactionClosure_BeginsAndRollsbackTransaction", test_InvalidatedNestingTransactionClosure_BeginsAndRollsbackTransaction),
    ]

}

// MARK: -

extension InactiveTransactionContextTests {

    static var allTests = [
        ("test_InitialState_ContextsAreInactive", test_InitialState_ContextsAreInactive),
        ("test_InitialState_ContextTransactionsAreNil", test_InitialState_ContextTransactionsAreNil),
    ]

}

// MARK: -

extension TransactionContextTests {

    static var allTests = [
        ("test_InitialState_ObjectStructureIsValid", test_InitialState_ObjectStructureIsValid),
        ("test_InitialState_CountersAreZero", test_InitialState_CountersAreZero),
    ]

}

// MARK: - XCTMain

XCTMain([
    testCase(ActiveTransactionContextNodeTests.allTests),
    testCase(ActiveTransactionContextRootTests.allTests),
    testCase(ActiveTransactionContextTests.allTests),
    testCase(InactiveTransactionContextNodeTests.allTests),
    testCase(InactiveTransactionContextRootTests.allTests),
    testCase(InactiveTransactionContextTests.allTests),
    testCase(TransactionContextTests.allTests),
])
