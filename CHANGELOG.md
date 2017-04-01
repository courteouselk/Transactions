# Change Log

## Unreleased

### Changed API

- Refactored `Transactable.isCommittable()` into `Transactable.hasCommittabilityError()` that 
  returns `Error?`
  - This allows transactable to be more specific about the problem (i.e. why the transaction can not 
    be committed).  The error returned by `.hasCommittabilityError()` will be thrown by 
    `.commitTransaction()`.

### Miscellaneous

- Improved documentation.

## [0.0.1](https://github.com/courteouselk/Transactions/releases/tag/0.0.1)

- Base functionality:
  - `Transactable`
  - `TransactionContext.createRoot(_)`
  - `TransactionContext.createNode(_, _)`
