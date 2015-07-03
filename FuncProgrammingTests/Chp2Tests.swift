//
//  Chp2Tests.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 03/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
//

import XCTest

class Chp2Tests: XCTestCase {

    func testFactorialReturns1ForEndCase() {
        XCTAssertEqual(1, factorial(0))
    }
    
    func testFactorial() {
        XCTAssertEqual(6, factorial(3))
    }
    
    func testFibEndCase() {
        XCTAssertEqual(0, fib(0))
    }
    
    func testFib() {
        XCTAssertEqual(0, fib(1))
        XCTAssertEqual(1, fib(2))
        XCTAssertEqual(1, fib(3))
        XCTAssertEqual(2, fib(4))
        XCTAssertEqual(3, fib(5))
        XCTAssertEqual(5, fib(6))
        XCTAssertEqual(8, fib(7))
    }
    
    func testDuplicateStrings() {
        let result : (one:String,two:String) = duplicateStrings(3, "hi", "bye")
        XCTAssertEqual("hihihi", result.one)
        XCTAssertEqual("byebyebye", result.two)
    }
}
