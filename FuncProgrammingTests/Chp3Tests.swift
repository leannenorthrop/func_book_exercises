//
//  Chp3Tests.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 03/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
//

import XCTest

class Chp3Tests: XCTestCase {
    let listOps = ListHelpers()
    
    func testEmptyList() {
        XCTAssertTrue(List<Int>().isEmpty)
    }
    
    func testList() {
        let lst = List<Int>(head:1, tail:List<Int>(head:2,tail:List<Int>(head:3)))
        XCTAssertFalse(lst.isEmpty)
    }
    
    func testPrintable() {
        let lst = List<Int>(head:1, tail:List<Int>(head:2,tail:List<Int>(head:3)))
        XCTAssertEqual("1, 2, 3, ", lst.description)
    }
    
    func testSum() {
        var lst : List<Int> = listOps.apply([1,2,3,5])
        XCTAssertEqual(11, listOps.sum(lst))
    }
    
    func testApply() {
        var lst : List<String> = listOps.apply(["a","b","c","d","e"])
        XCTAssertEqual("a", lst[0]!)
        XCTAssertEqual("c", lst[2]!)
        XCTAssertEqual("d", lst[3]!)
        XCTAssertEqual("e", lst[4]!)
    }
    
    func testProduct() {
        var lst : List<Float> = listOps.apply([1,2,3,5])
        XCTAssertEqual(30, listOps.product(lst))
    }
    
    // Not sure of the relevance of currying drop as 
    // type inference in swift seems to handle closure types
    // perfectly well as seen in Exercise 3.5 below
    func testCurriedDrop() {
        var lst : List<Int> = listOps.apply([1,3,5, 7,8,52,5,7])
        lst = listOps.drop(lst)(f:{ $0 < 10 })
        XCTAssertEqual(52, lst[0]!)
        XCTAssertEqual(5, lst[1]!)
        XCTAssertEqual(7, lst[2]!)
    }
    
    func testExercise3_2() {
        var lst : List<String> = listOps.apply(["a","b","c","d","e"])
        lst = lst.tail2()!
        XCTAssertEqual("b", lst[0]!)
        XCTAssertEqual("c", lst[1]!)
        XCTAssertEqual("d", lst[2]!)
        XCTAssertEqual("e", lst[3]!)
    }
    
    func testExercise3_3() {
        var lst : List<String> = listOps.apply(["a","b","c","d","e"])
        lst = lst.setHead("z")
        XCTAssertEqual("z", lst[0]!)
        XCTAssertEqual("b", lst[1]!)
        XCTAssertEqual("c", lst[2]!)
        XCTAssertEqual("d", lst[3]!)
        XCTAssertEqual("e", lst[4]!)
    }

    func testExercise3_4() {
        var lst : List<Int> = listOps.apply([1,3,5,7,8,52,5,7])
        lst = listOps.drop(lst,n:3)
        XCTAssertEqual(7, lst[0]!)
        XCTAssertEqual(8, lst[1]!)
        XCTAssertEqual(52, lst[2]!)
    }
    
    func testExercise3_5() {
        var lst : List<Int> = listOps.apply([1,3,5, 7,8,52,5,7])
        lst = listOps.drop(lst) { $0 < 10 }
        XCTAssertEqual(52, lst[0]!)
        XCTAssertEqual(5, lst[1]!)
        XCTAssertEqual(7, lst[2]!)
    }
    
    func testExercise3_6() {
        var lst : List<Int> = listOps.apply([1,3,8,52])
        let result1 = listOps.head2(lst)
        XCTAssertEqual(1, result1[0]!)
        XCTAssertEqual(3, result1[1]!)
        XCTAssertEqual(8, result1[2]!)
        XCTAssertNil(result1[3])
    }
}
