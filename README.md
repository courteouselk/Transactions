# Transactions

[![License](https://img.shields.io/github/license/courteouselk/Transactions.svg?maxAge=2592000)](https://raw.githubusercontent.com/courteouselk/Transactions/master/LICENSE)
[![Swift 4](https://img.shields.io/badge/Swift-4-E9392C.svg?style=flat)](https://developer.apple.com/swift/)
[![GitHub release](https://img.shields.io/github/release/courteouselk/Transactions.svg)](https://github.com/courteouselk/Transactions/releases)
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20Linux-333333.svg)

[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Transactions.svg)](https://cocoapods.org/pods/Transactions)

[![Travis CI](https://travis-ci.org/courteouselk/Transactions.svg?branch=swift4)](https://travis-ci.org/courteouselk/Transactions)
[![codecov](https://codecov.io/gh/courteouselk/Transactions/branch/master/graph/badge.svg)](https://codecov.io/gh/courteouselk/Transactions)
[![documentation](https://img.shields.io/badge/documentation-available-brightgreen.svg)](http://northernforest.nl/Transactions/)

[Transactions](https://github.com/courteouselk/Transactions) framework facilitates making atomic changes to the model:

- It provides a generic mechanism to "link" coherent hierarchies of objects that are supposed to change their state synchronously and atomically.
- It defines call-back functions that are triggered on every object at every transaction start, pre-commit integrity check, commit, and rollback.
- It provides convenience method to wrap transactional code in closures.  Such closures will be pre-pended by transaction start callbacks, post-pended by either commits or rollbacks, and will have an implicit integrity check ran for every member of the transaction context.

This approach allows to encapsulate constraints checking and backup/restore operations within each individual class, thus placing related code together and making the whole logic clearer and easier to maintain.

## Summary (TL;DR)

This will work fine (`chart1` object will have two elements that sum up to 100 percent in total):

````swift
let chart1 = PieChart()

do {
    try chart1.doTransactionally({
        chart1.addElement(label: "Part #1", percentage: 25)
        chart1.addElement(label: "Part #2", percentage: 75)
    })
} catch {
    print(error)
}

for e in chart1.elements.values {
    print("\(e.label), \(e.percentage)%")
}
````

.. while this will throw an error while leaving the `chart2` without any elements added:

````swift
let chart2 = PieChart()

do {
    try chart2.doTransactionally({
        chart2.addElement(label: "Part #1", percentage: 25)
        chart2.addElement(label: "Part #2", percentage: 80)
    })
} catch {
    print(error)
}
````

## Details

Let's have a pie-chart object that will contain some elements that represent percentages of the chart area.  Total sum of the percentages must always be 100, each percentage must be greater than zero and not greater than 100.

Here is how the `PieChart` class could have been implemented:

````swift
import Transactions

class PieChart : Transactable  {

    private (set) var elements: [String: PieChartElement] = [:]
    private var elementsBackup: [String: PieChartElement] = [:] // Backup to be used in case of rollback

    // Transaction context is a mediator class that "links" transaction
    // tree together.  There are two kinds of it, a root and a node.
    var transactionContext: TransactionContext { return _transactionContext! }
    private var _transactionContext: TransactionContext? = nil

    init() {
        _transactionContext = TransactionContext.createRoot(owner: self)
    }

    func onBegin(transaction: Transaction) {
        // Back up of internal state is not needed because onCommit(), onRollback() and initialization
        // make it sure that backup is always up to date anyway.
    }

    func onValidateCommit() throws {
        guard elements.count == 0 || elements.values.reduce(0, { $0 + $1.percentage }) == 100 else {
            throw PieChartError.totalPercentageIsNot100
        }
    }

    func onCommit(transaction: Transaction) {
        elementsBackup = elements // Overwrite the backup to release (potentially) deleted objects
    }

    func onRollback(transaction: Transaction) {
        elements = elementsBackup // Restore the state from backup
    }

    // ...

}
````

.. the implementation of `onValidateCommit()` verifies that the chart is either empty, or has total sum of all percentages equal to exactly 100.

The implementation of `PieChartElement.onValidateCommit()` will check whether each individual percentage is within (0, 100] range:

````swift
class PieChartElement : Transactable {

    let label: String

    var percentage: Int {
        get { return _percentage }
        set { assert(transactionIsActive); _percentage = newValue }
    }
    private var _percentage: Int
    private var _percentageBackup: Int

    var transactionContext: TransactionContext { return _transactionContext! }
    private var _transactionContext: TransactionContext? = nil

    init(chart: PieChart, label: String, percentage: Int) {
        self.label = label
        self._percentage = percentage
        self._percentageBackup = percentage
        _transactionContext = TransactionContext.createNode(owner: self, parent: chart)
    }

    func onBegin(transaction: Transaction) { }

    func onValidateCommit() throws {
        guard _percentage > 0 else {
            throw PieChartError.elementIsNotPositive
        }
        guard _percentage <= 100 else {
            throw PieChartError.elementIsGreaterThan100
        }
    }

    func onCommit(transaction: Transaction) {
        _percentageBackup = _percentage
    }

    func onRollback(transaction: Transaction) {
        _percentage = _percentageBackup
    }

}
````

The rest of the example code (for the sake of completeness):

````swift
class PieChartElement : Transactable {

    let label: String

    var percentage: Int {
        get { return _percentage }
        set { assert(transactionIsActive); _percentage = newValue }
    }
    private var _percentage: Int
    private var _percentageBackup: Int

    var transactionContext: TransactionContext { return _transactionContext! }
    private var _transactionContext: TransactionContext? = nil

    init(chart: PieChart, label: String, percentage: Int) {
        self.label = label
        self._percentage = percentage
        self._percentageBackup = percentage
        _transactionContext = TransactionContext.createNode(owner: self, parent: chart)
    }

    func onBegin(transaction: Transaction) { }

    func onValidateCommit() throws {
        guard _percentage > 0 else {
            throw PieChartError.elementIsNotPositive
        }
        guard _percentage <= 100 else {
            throw PieChartError.elementIsGreater100
        }
    }

    func onCommit(transaction: Transaction) {
        _percentageBackup = _percentage
    }

    func onRollback(transaction: Transaction) {
        _percentage = _percentageBackup
    }

}

enum PieChartError : Error {
    case elementIsNotPositive
    case elementIsGreaterThan100
    case totalPercentageIsNot100
}
````

Finally, the way it could have been used in Swift Playground:

````swift
let chart = PieChart()

do {
    try chart.doTransactionally({
        chart.addElement(label: "Part #1", percentage: 50) // Try to change 50 to 60
        chart.addElement(label: "Part #2", percentage: 50)
    })
} catch {
    print(error)
}

for e in chart.elements.values {
    print("\(e.label), \(e.percentage)%")
}
````

If you run the code above in a playground and change the percentages (make them too big, or negative, or not adding up to 100) then you will see that whenever any of the constraints is violated the transaction that made inconsistent changes is rolled back to the previous state (thus the model always remains consistent).

This makes it possible to simplify the way changes are applied to the model because you will be able to just change what has to be changed, and then if anything is wrong an exception will be thrown, so you can handle it, but still the data will stay consistent.
