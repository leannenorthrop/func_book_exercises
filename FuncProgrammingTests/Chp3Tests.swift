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
    
    func testTail() {
        var lst : List<String> = listOps.apply(["a","b","c","d","e"])
        lst = lst.tail2()!
        XCTAssertEqual("b", lst[0]!)
        XCTAssertEqual("c", lst[1]!)
        XCTAssertEqual("d", lst[2]!)
        XCTAssertEqual("e", lst[3]!)
    }
    
    func testReplaceFirst() {
        var lst : List<String> = listOps.apply(["a","b","c","d","e"])
        lst = lst.setHead("z")
        XCTAssertEqual("z", lst[0]!)
        XCTAssertEqual("b", lst[1]!)
        XCTAssertEqual("c", lst[2]!)
        XCTAssertEqual("d", lst[3]!)
        XCTAssertEqual("e", lst[4]!)
    }
    
    func testDrop() {
        var lst : List<Int> = listOps.apply([1,3,5, 7,8,52,5,7])
        lst = listOps.drop(lst) { $0 < 10 }
        XCTAssertEqual(52, lst[0]!)
        XCTAssertEqual(5, lst[1]!)
        XCTAssertEqual(7, lst[2]!)
    }
}
