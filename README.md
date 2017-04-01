# Transactions

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-E9392C.svg?style=flat)](https://developer.apple.com/swift/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Simple framework to facilicate the management of transactional changes to the model.

The core of the framework is formed by `Transactable` protocol and `TransactionContext` helper class.

**Example:**

A type that can be managed by the framework should implement `Transactable` protocol.  Objects being managed should form a tree structure with a single object at the root (a.k.a. context root):

````swift
class Library : Transactable {

    private var _transactionContext: TransactionContext? = nil

    var transactionContext: TransactionContext {
        return _transactionContext!
    }

    init() {
        // Library object will be the transaction context root
        _transactionContext = TransactionContext.createRoot(owner: self)
    }

    func onBegin(transaction: Transaction) {
        // Prepare for new transaction    
    }

    func hasCommittabilityError() -> Error? {
        // Verify the staged changes and return `nil` if they are Ok to commit, 
        // otherwise return the error describing the problem
        return nil
    }

    func onCommit(transaction: Transaction) {
        // Incorporate the staged changes into object's actual state
    }

    func onRollback(transaction: Transaction) {
        // Discard staged changes
    }
    
}
````

Other objects will form the nodes of a tree (context nodes):

````swift
class Book : Transactable {

    unowned let library: Library

    let name: String

    private var _transactionContext: TransactionContext? = nil

    var transactionContext: TransactionContext {
        return _transactionContext!
    }

    init(library: Library, name: String) {
        self.library = library
        self.name = name

        // Books in a library will be at transaction context nodes
        _transactionContext = TransactionContext.createNode(owner: self, parent: library)
    }

    func onBegin(transaction: Transaction) {
        // Prepare for new transaction    
    }

    func hasCommittabilityError() -> Error? {
        // Verify the staged changes and return `nil` if they are Ok to commit, 
        // otherwise return the error describing the problem
        return nil
    }

    func onCommit(transaction: Transaction) {
        // Incorporate the staged changes into object's actual state
    }

    func onRollback(transaction: Transaction) {
        // Discard staged changes
    }

}
````

Now, to put all that into use:

````swift
import Transactions

let library = Library(name: "Main")

let bookA = Book(library: library, name: "A")
let bookB = Book(library: library, name: "B")

// No transaction is active

assert(!library.transactionIsActive)
assert(!bookA.transactionIsActive)
assert(!bookB.transactionIsActive)

assert(library.activeTransaction == nil)
assert(bookA.activeTransaction == nil)
assert(bookB.activeTransaction == nil)

// Starting a transaction will trigger `onBegin` for everry object in the tree,
// set the status of `transactionIsActive` to `true`, set `activeTransaction` to
// the descriptor for the currently active transaction.

let transaction = try! bookA.beginTransaction()

assert(library.transactionIsActive)
assert(bookA.transactionIsActive)
assert(bookB.transactionIsActive)

assert(library.activeTransaction == transaction)
assert(bookA.activeTransaction == transaction)
assert(bookB.activeTransaction == transaction)

// Committing the transaction will also propagate through the whole tree

try! bookB.commitTransaction()

assert(!library.transactionIsActive)
assert(!bookA.transactionIsActive)
assert(!bookB.transactionIsActive)

assert(library.activeTransaction == nil)
assert(bookA.activeTransaction == nil)
assert(bookB.activeTransaction == nil)
````
