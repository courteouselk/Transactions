//
//  XCTExtensions.swift
//  Transactions
//
//  Created by Anton Bronnikov on 30/04/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest

func XCTAssertThrowsSwiftError(_ expression: (Void) throws -> Void, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line, _ errorHandler: (Error) -> Swift.Void = { _ in }) {
    do {
        try expression()
        XCTFail("XCTAssertThrowsError did not throw an error - \(message())", file: file, line: line)
    }
    catch {
        errorHandler(error)
    }

}
