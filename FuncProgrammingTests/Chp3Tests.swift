//
//  Chp3Tests.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 03/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
//

import XCTest

class Chp3Tests: XCTestCase {

    func testEmptyList() {
        XCTAssertTrue(List<Int>().isEmpty)
    }
    
    func testList() {
        XCTAssertFalse(List<Int>(arr:1,2,3).isEmpty)
    }
    
    func testSubscript() {
        var lst = List<String>(arr:"a","b","c","d","e")
        XCTAssertEqual("a", lst[0]!)
        XCTAssertEqual("c", lst[2]!)
        XCTAssertEqual("d", lst[3]!)
    }
    
    func testSum() {
        var lst = List<Int>(arr:1,2,3,5)
        XCTAssertEqual(11, ListHelpers().sum(lst))
    }
    
    func testApply() {
        var lst : List<String> = ListHelpers().apply(["a","b","c","d","e"])
        XCTAssertEqual("a", lst[0]!)
        XCTAssertEqual("c", lst[2]!)
        XCTAssertEqual("d", lst[3]!)
        XCTAssertEqual("e", lst[4]!)
    }
    
    func testProduct() {
        var lst = List<Float>(arr:1,2,3,5)
        XCTAssertEqual(30, ListHelpers().product(lst))
    }
}
