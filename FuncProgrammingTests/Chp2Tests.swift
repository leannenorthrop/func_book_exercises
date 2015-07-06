//
//  Chp2Tests.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 03/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
//

import XCTest

class Chp2Tests: XCTestCase {

    // page 20
    func testFactorialReturns1ForEndCase() {
        XCTAssertEqual(1, factorial(0))
    }

    // page 20
    func testFactorial() {
        XCTAssertEqual(6, factorial(3))
    }
    
    // page 21
    func testExercise2_1() {
        XCTAssertEqual(0, fib(0))
        XCTAssertEqual(0, fib(1))
        XCTAssertEqual(1, fib(2))
        XCTAssertEqual(1, fib(3))
        XCTAssertEqual(2, fib(4))
        XCTAssertEqual(3, fib(5))
        XCTAssertEqual(5, fib(6))
        XCTAssertEqual(8, fib(7))
    }

    // page 21
    func testListing2_2() {
        XCTAssertEqual("The absolute value of -1 is 1", Listing2_2().formatAbs(-1))
        XCTAssertEqual("The factorial value of 3 is 6", Listing2_2().formatFactorial(3))
    }
    
    // page 21
    func testListing2_2HOF() {
        XCTAssertEqual("The absolute value of -1 is 1", Listing2_2_HigherOrderFunction().formatResult("absolute", n: -1, f: abs))
        XCTAssertEqual("The factorial value of 3 is 6", Listing2_2_HigherOrderFunction().formatResult("factorial", n: 3, f:factorial))
    }
    
    func testDuplicateStrings() {
        let result : (one:String,two:String) = duplicateStrings(3, "hi", "bye")
        XCTAssertEqual("hihihi", result.one)
        XCTAssertEqual("byebyebye", result.two)
    }
    
    func testListing2_3() {
        let arr = Array(map(stride(from: 1, through: 24, by: 2)){$0})
        let foundIndex = findFirst(arr){
            i in
            i == 13
        }
        XCTAssertEqual(6, foundIndex)
    }
    
    func testExercise2_2() {
        let arr = Array(map(stride(from: 1, through: 24, by: 2)){$0})
        let itsSorted = isSorted(arr){
            a,b in
            a < b
        }
        XCTAssertTrue(itsSorted)
        let arr2 = [2,9,8,42,3,2,0]
        let itsSorted2 = isSorted(arr2){
            a,b in
            a < b
        }
        XCTAssertFalse(itsSorted2)
        let itsSorted3 = isSorted(arr2,<)
        XCTAssertFalse(itsSorted3)
    }
    
    func testPartial1() {
        let timesItByThree : Int -> Int = partial1(3) { $0 * $1 }
        XCTAssertEqual(9, timesItByThree(3))
        XCTAssertEqual(12, timesItByThree(4))
    }
    
    // https://robots.thoughtbot.com/introduction-to-function-currying-in-swift
    func testPartial2() {
        let timesItByThree = partial2(3,{ $0 * $1 })
        XCTAssertEqual(9, timesItByThree(b:3))
        XCTAssertEqual(12, timesItByThree(b:4))
    }
    
    func testCompose() {
        let f = {2*$0}
        let g = {4+$0}
        let gThenf = compose(f, g)
        XCTAssertEqual(18, gThenf(5))
    }
    
    // Page 27
    func testExercise2_3() {
        let f : (Int,Int) -> Int = {$0*$1}
        let curried = curry(f)
        XCTAssertEqual(6, curried(3)(2))
    }
    
    // Page 27
    func testExercise2_4() {
        let f : (Int,Int) -> Int = {$0*$1}
        let curried = curry(f)
        XCTAssertEqual(6, curried(3)(2))
        let uncurried = uncurry(curried)
        XCTAssertEqual(6, uncurried(3,2))
    }
}
