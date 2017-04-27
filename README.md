# Transactions

[![License](https://img.shields.io/github/license/courteouselk/Transactions.svg?maxAge=2592000)](https://raw.githubusercontent.com/courteouselk/Transactions/master/LICENSE)
[![Swift 3.1](https://img.shields.io/badge/Swift-3.1-E9392C.svg?style=flat)](https://developer.apple.com/swift/)
[![GitHub release](https://img.shields.io/github/release/courteouselk/Transactions.svg)](https://github.com/courteouselk/Transactions/releases)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Travis CI](https://travis-ci.org/courteouselk/Transactions.svg?branch=master)](https://travis-ci.org/courteouselk/Transactions)
[![codecov](https://codecov.io/gh/courteouselk/Transactions/branch/master/graph/badge.svg)](https://codecov.io/gh/courteouselk/Transactions)

Simple framework to facilicate the management of transactional changes to the model.

The core of the framework is formed by `Transactable` protocol and `TransactionContext` helper class.

## An oversimplified example

**Library class**

````swift
class Library : Transactable {

    enum Error : Swift.Error {
        case tooManyBooks(name: String)
    }

    private (set) var books: [String: Book] = [:]
    private var booksInTranaction: [String: Book] = [:]

    private var _transactionContext: TransactionContext? = nil
    var transactionContext: TransactionContext { return _transactionContext! }

    init() {
        _transactionContext = TransactionContext.createRoot(owner: self)
    }

    func onBegin(transaction: Transaction) { booksInTranaction = books }

    func onCommit(transaction: Transaction) { books = booksInTranaction }

    func onRollback(transaction: Transaction) { booksInTranaction = [:] }

    func add(book: Book) throws {
        try transaction {
            if let knownBook = booksInTranaction[book.name] {
                try knownBook.add()
            } else {
                booksInTranaction[book.name] = book
                try book.add()
            }
        }
    }

    func list() {
        books.values.forEach({ print("\"\($0.name)\" : \($0.count)") })
    }

}
````

**Book class**

````swift
class Book : Transactable {

    unowned let library: Library
    let name: String

    private (set) var count = 0
    private var countInTransaction = 0

    private var _transactionContext: TransactionContext? = nil
    var transactionContext: TransactionContext { return _transactionContext! }

    init(library: Library, name: String) {
        self.library = library
        self.name = name
        _transactionContext = TransactionContext.createNode(owner: self, parent: library)
    }

    func onBegin(transaction: Transaction) { countInTransaction = count }

    func onCommit(transaction: Transaction) { count = countInTransaction }

    func onRollback(transaction: Transaction) { countInTransaction = 0 }

    func onValidateCommit() throws {
        if countInTransaction > 2 {
            throw Library.Error.tooManyBooks(name: name)
        }
    }

    func add() throws {
        try transaction { countInTransaction += 1 }
    }

}
````

**Result**

````swift
let library = Library()
let book = Book(library: library, name: "Some book")

do {
    try library.add(book: book)
    library.list()
    try library.add(book: book)
    library.list()
    try library.add(book: book)
    library.list()
} catch {
    print("Error: \(error)")
}

/* Playground prints:

   "Some book" : 1
   "Some book" : 2
   Error: tooManyBooks("Some book")

 */

````
