//
//  Chp5Tests.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 09/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
//

import XCTest

class Chp5Tests: XCTestCase {

    func testLazyVal() {
        var lazyVar = LazyVal<Int>({
            println("Now init value...")
            return 3
        })
        let val = lazyVar.value
        println("Value is \(lazyVar.value)")
        
        var lazyVar2 = LazyVal<Int>({4})
        let val2 = lazyVar2.value
        println("Value is \(lazyVar2.value)")
    }

    // Page 69
    func testExercise5_1() {
        let lst = apply([{1},{3},{5},{7}])
        let s = lst.toList()
        
    }
    
    // Page 70
    func testExercise5_2_Take() {
        let lst = apply([{1},{3},{5},{7}])
        let s = lst.take(2)
        let printablestream = s.toList()
        println(printablestream)
    }

    // Page 70
    func testExercise5_2_Drop() {
        let lst = apply([{1},{3},{5},{7}])
        let s = lst.drop(2)
        let printablestream = s.toList()
        println(printablestream)
    }
    
    // Page 70
    func testExercise5_3() {
        let lst = apply([{1},{3},{5},{7},{10}])
        let s = lst.takeWhile{$0 < 10}
        let printablestream = s.toList()
        println(printablestream)
    }
    
    func testExist2() {
        let lst = apply([{1},{3},{5},{7},{10}])
        let s = lst.exists2{$0 == 5}
        XCTAssertTrue(s)
    }
    
    // Page 71
    func testExercise5_4() {
        let lst = apply([{1},{3},{5},{7},{10}])
        XCTAssertFalse(lst.forAll{$0 < 7})
        XCTAssertTrue(lst.forAll{$0 < 11})
    }
    
    // Page 71
    func testExercise5_5() {
        let lst = apply([{1},{3},{5},{7},{10}])
        let lstResult = lst.takeWhile2{$0 < 7}
        let printablestream = lstResult.toList()
        println(printablestream)
    }
    
    // Page 71
    func testExercise5_6() {
        let lst = apply([{1},{3},{5},{7},{10}])
        let lstResult = lst.headOption2()
        switch lstResult {
        case .None: XCTAssertTrue(false)
        case .Some(let l) :
            let printablestream = l.toList()
            println(printablestream)
        }

    }
}
