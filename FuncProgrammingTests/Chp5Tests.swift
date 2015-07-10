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
    
    // Page 72
    func testExercise5_7_Append() {
        let lst = apply([{1},{3},{5},{7},{10}])
        let lstResult = lst.append({11})
        let printablestream = lstResult.toList()
        println(printablestream)
    }
    
    // Page 72
    func testExercise5_7_Filter() {
        let lst = apply([{1},{3},{5},{7},{10}])
        let lstResult = lst.filter({$0<7})
        let printablestream = lstResult.toList()
        println(printablestream)
    }
    
    // Page 72
    func testExercise5_7_Map() {
        let lst = apply([{1},{3},{5},{7},{10}])
        let lstResult = lst.map({$0*10})
        let printablestream = lstResult.toList()
        println(printablestream)
    }
    
    // Page 72
    func testExercise5_7_FlatMap() {
        let lst = apply([{1},{3},{5},{7},{10}])
        let lstResult = lst.flatMap({
            int in
            Stream<Int>({int*11})
        })
        let printablestream = lstResult.toList()
        println(printablestream)
    }
    
    func testStream() {
        let lst = apply([{1},{2},{3},{4},{5}])
        let l = lst.map({$0+10}).filter({$0%2==0}).toList()
        println(l)
    }
    
    // Page 72
    func testExercise5_8() {
        let lst = constant(5).take(10)
        println(lst.toList())
    }
    
    // Page 72
    func testExercise5_9() {
        let lst = from(5).take(10)
        println(lst.toList())
    }
    
    // Page 75
    func testExercise5_11() {
        let lst = unfold(2, {
            s in
            Option.Some(some:(s,(s*10)))
        }).take(5).toList()
        println(lst)
    }

    // Page 75
    func testExercise5_12_From() {
        let lst = from2(3).take(5).toList()
        println(lst)
    }
    
    // Page 75
    func testExercise5_12_Constant() {
        let lst = constant2(3).take(5).toList()
        println(lst)
    }
    
    // Page 75
    func testExercise5_12_Ones() {
        let lst = ones2().take(5).toList()
        println(lst)
    }
    
    // Page 76
    func testExercise5_13_TakeN() {
        let lst = apply([{1},{2},{3},{4},{5},{6},{7},{8}])
        let lst2 = lst.take2(5).toList()
        println(lst2)
    }
    
    // Page 76
    func testExercise5_13_TakeWhile() {
        let lst = apply([{1},{2},{3},{4},{5},{6},{7},{8}])
        let lst2 = lst.takeWhile3({$0<5}).toList()
        println(lst2)
    }
    
    // Page 76
    func testExercise5_13_Map() {
        let lst = apply([{1},{2},{3},{4},{5},{6},{7},{8}])
        let lst2 = lst.map2({$0*12}).toList()
        println(lst2)
    }
    
    // Page 76
    func testExercise5_13_ZipWith() {
        let lst = apply([{1},{2},{3},{4},{5},{6},{7},{8}])
        let lst2 = apply([{10},{20},{30},{40},{50},{60},{70},{80}])
        let lst3 = lst.zipWith(lst2){$0+$1}.toList()
        println(lst3)
    }
    
    // Page 76
    func testExercise5_13_ZipAll() {
        let lst = apply([{1},{2},{3},{4},{5},{6},{7},{8}])
        let lst2 = apply([{10},{20},{30},{40}])
        let lst3 = lst.zipAll(lst2)
    }
    
    // Page 76
    func testExercise5_14() {
        let lst = apply([{1},{2},{3},{4},{5},{6},{7},{8}])
        let lst2 = apply([{1},{2},{3},{4}])
        XCTAssertTrue(startsWith(lst,lst2))
        let lst3 = apply([{10},{20},{30},{40}])
        XCTAssertFalse(startsWith(lst,lst3))
    }
    
    // Page 76
    func testExercise5_15() {
        let lst = apply([{1},{2},{3},{4},{5},{6},{7},{8}])
        let lst2 = lst.tails()
        let str = lst2.map2{$0.toList().description}
        println(str.toList().description)
    }
    
    // Page 76
    func testHasSubsequence() {
        let lst = apply([{1},{2},{3},{4},{5},{6},{7},{8}])
        let lst2 = apply([{3},{4},{5},{6}])
        XCTAssertTrue(hasSubsequence(lst,lst2))
        let lst3 = apply([{10},{20},{30},{40}])
        XCTAssertFalse(hasSubsequence(lst,lst3))
    }
}
