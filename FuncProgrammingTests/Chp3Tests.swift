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
    
    // page 30
    func testEmptyList() {
        XCTAssertTrue(List<Int>().isEmpty)
    }

    // page 30
    func testList() {
        let lst = List<Int>(head:1, tail:List<Int>(head:2,tail:List<Int>(head:3)))
        XCTAssertFalse(lst.isEmpty)
    }
    
    // page 30
    func testPrintable() {
        let lst = List<Int>(head:1, tail:List<Int>(head:2,tail:List<Int>(head:3)))
        XCTAssertEqual("(1, 2, 3)", lst.description)
    }
    
    // page 30
    func testSum() {
        var lst : List<Int> = listOps.apply([1,2,3,5])
        XCTAssertEqual(11, listOps.sum(lst))
    }
    
    // page 30
    func testSum2() {
        var lst : List<Int> = listOps.apply([1,2,3,5])
        XCTAssertEqual(11, listOps.sum2(lst))
    }
    
    // page 30
    func testApply() {
        var lst : List<String> = listOps.apply(["a","b","c","d","e"])
        XCTAssertEqual("a", lst[0]!)
        XCTAssertEqual("c", lst[2]!)
        XCTAssertEqual("d", lst[3]!)
        XCTAssertEqual("e", lst[4]!)
    }
    
    // page 30
    func testProduct() {
        var lst : List<Float> = listOps.apply([1,2,3,5])
        XCTAssertEqual(30, listOps.product(lst))
    }
    
    // page 30
    func testProduct2() {
        var lst : List<Float> = listOps.apply([1,2,3,5])
        XCTAssertEqual(30, listOps.product2(lst))
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
    
    // page 35
    func testExercise3_2() {
        var lst : List<String> = listOps.apply(["a","b","c","d","e"])
        lst = lst.tail2()!
        XCTAssertEqual("b", lst[0]!)
        XCTAssertEqual("c", lst[1]!)
        XCTAssertEqual("d", lst[2]!)
        XCTAssertEqual("e", lst[3]!)
    }

    // page 36
    func testExercise3_3() {
        var lst : List<String> = listOps.apply(["a","b","c","d","e"])
        lst = lst.setHead("z")
        XCTAssertEqual("z", lst[0]!)
        XCTAssertEqual("b", lst[1]!)
        XCTAssertEqual("c", lst[2]!)
        XCTAssertEqual("d", lst[3]!)
        XCTAssertEqual("e", lst[4]!)
    }

    // page 36
    func testExercise3_4() {
        var lst : List<Int> = listOps.apply([1,3,5,7,8,52,5,7])
        lst = listOps.drop(lst,n:3)
        XCTAssertEqual(7, lst[0]!)
        XCTAssertEqual(8, lst[1]!)
        XCTAssertEqual(52, lst[2]!)
    }
    
    // page 36
    func testExercise3_5() {
        var lst : List<Int> = listOps.apply([1,3,5, 7,8,52,5,7])
        lst = listOps.drop(lst) { $0 < 10 }
        XCTAssertEqual(52, lst[0]!)
        XCTAssertEqual(5, lst[1]!)
        XCTAssertEqual(7, lst[2]!)
    }
    
    // page 37
    func testExercise3_6() {
        var lst : List<Int> = listOps.apply([1,3,8,52])
        let result1 = listOps.head2(lst)
        XCTAssertEqual(1, result1[0]!)
        XCTAssertEqual(3, result1[1]!)
        XCTAssertEqual(8, result1[2]!)
        XCTAssertNil(result1[3])
    }
    
    func testPrintExercise3_6() {
        var lst : List<Int> = listOps.apply([1,3,8,52])
        let result1 = listOps.headPrinting(lst)
        XCTAssertEqual(1, result1[0]!)
        XCTAssertEqual(3, result1[1]!)
        XCTAssertEqual(8, result1[2]!)
        XCTAssertNil(result1[3])
    }

    // page 40
    func testExercise3_7() {
        var lst : List<Float> = listOps.apply([1,3,0,8,52])
        let result1 = listOps.product3(lst)
        XCTAssertEqual(Float(0), result1)
    }

    // page 40
    func testExercise3_8() {
        var lst : List<Int> = listOps.apply([1,2,3])
        let result = listOps.foldRight(lst, b:List<Int>())(f: {List<Int>(head:$0,tail:$1)})
    }
    
    func testPrintingExercise3_8() {
        var lst : List<Int> = listOps.apply([1,2,3])
        let result = listOps.foldRightPrinting(lst, b:List<Int>())(f: {List<Int>(head:$0,tail:$1)})
    }
    
    // page 40
    func testExercise3_9() {
        var lst : List<Int> = listOps.apply([1,3,5, 7,8,52,5,7])
        let length1 = listOps.length(lst)
        XCTAssertEqual(8, length1)
        var lst2 : List<Int> = listOps.apply([1,3,5,7])
        let length2 = listOps.length(lst2)
        XCTAssertEqual(4, length2)

    }
    
    // page 40
    func testExercise3_10a() {
// stack overflow =        let array = (0..<10000).map { $0 }
        let array = (0..<1000).map { $0 }
        var lst : List<Int> = listOps.apply(array)
        println("List length = \(listOps.length(lst))")
    }
    
    // page 40
    func testExercise3_10b() {
        var lst : List<Double> = listOps.apply([10.0,5.0])
        let result = listOps.foldLeft(lst, b:2.0) {
            b,a in
            b/a
        }
        let result2 = listOps.foldLeftIterative(lst, b:2.0) {
            b,a in
            b/a
        }
        println("Fold left / = \(result)")
        println("Reduce / = \(reduce([10.0,5.0], 2.0,{$0/$1}))")
        println("Fold left iterative / = \(result2)")
    }
    
    // page 41
    func testExercise3_11() {
        var lst : List<Int> = listOps.apply([1,3,5,7,8,52,5,7])
        let length1 = listOps.lengthFoldLeft(lst)
        XCTAssertEqual(8, length1)
        var lst2 : List<Int> = listOps.apply([1,3,5,7])
        let length2 = listOps.lengthFoldLeft(lst2)
        XCTAssertEqual(4, length2)
        let sum = listOps.sumFoldLeft(lst2)
        XCTAssertEqual(16, sum)
        var lst3 : List<Float> = listOps.apply([Float(1),Float(3),Float(5),Float(7)])
        let product = listOps.productFoldLeft(lst3)
        XCTAssertEqual(105, product)
        
    }

    // page 41
    func testExercise3_12() {
        let lst : List<Int> = listOps.apply([1,3,5,7,8,52])
        let lst2 = listOps.reverse(lst)
        println(lst2)
        XCTAssertEqual(52, lst2[0]!)
    }
    
    // page 41
    func testExercise3_14() {
        let lst : List<Int> = listOps.apply([1,3,5,7,8,52])
        let lst2 = listOps.append(lst, a: 33)
        println(lst2)
        XCTAssertEqual(33, lst2[6]!)
    }
    
    // page 41
    func testExercise3_15() {
        let lst1 : List<Int> = listOps.apply([1,2,3])
        let lst2 : List<Int> = listOps.apply([4,5,6])
        let lst3 : List<List<Int>> = listOps.apply([lst1,lst2])
        println(lst3)
        println(listOps.flatten(lst3))
        XCTAssertEqual(1, listOps.flatten(lst3)[0]!)
    }
    
    /// page 42
    func testExercise3_16() {
        let lst : List<Int> = listOps.apply([1,3,5,7,8,52])
        let results = listOps.addOne(lst)
        println(results)
        XCTAssertEqual(2, results[0]!)
    }
    
    /// page 42
    func testExercise3_17() {
        let lst : List<Double> = listOps.apply([1.0,3.0,5.0,7.0,8.0,52.0])
        let results = listOps.toString(lst)
        XCTAssertEqual("1.0", results[0]!)
    }
    
    /// page 42
    func testExercise3_18() {
        let lst : List<Double> = listOps.apply([1.0,3.0,5.0,7.0,8.0,52.0])
        let results = listOps.map(lst)(f:{$0*4})
        XCTAssertEqual(4.0, results[0]!)
    }
    
    /// page 42
    func testExercise3_19() {
        let lst : List<Int> = listOps.apply([1,3,5,7,8,52])
        let isOdd : Int -> Bool = { int -> Bool in return ((int%2)==0) }
        let results = listOps.filter(lst)(f:isOdd)
        println(results)
        XCTAssertEqual(8, results[0]!)
    }
    
    /// page 42
    func testExercise3_20() {
        let lst : List<Int> = listOps.apply([1,2,3])
        let copy : Int -> List<Int> = { int -> List<Int> in return List<Int>(head:int, tail:List<Int>(head:int)) }
        let results = listOps.flatMap(lst)(f:copy)
        println(results)
        XCTAssertEqual(1, results[0]!)
        XCTAssertEqual(1, results[1]!)
        
        let multiply : Int -> List<Int> = { int -> List<Int> in return List<Int>(head:int, tail:List<Int>(head:int*2)) }
        let results2 = listOps.flatMap(lst)(f:multiply)
        println(results2)
        XCTAssertEqual(1, results2[0]!)
        XCTAssertEqual(2, results2[1]!)
    }
    
    /// page 43
    func testExercise3_21() {
        let lst : List<Int> = listOps.apply([1,3,5,7,8,52,3,2])
        let isOdd : Int -> Bool = { int -> Bool in return ((int%2)==0) }
        let results = listOps.filter2(lst)(f:isOdd)
        println(results)
        XCTAssertEqual(8, results[0]!)
    }
    
    /// page 43
    func testExercise3_22() {
        let lst : List<Int> = listOps.apply([1,3,5,7,8,52,3,2])
        let results = listOps.addLists(lst,lst2:lst)
        println(results)
        XCTAssertEqual(2, results[0]!)
        XCTAssertEqual(6, results[1]!)
    }
    
    func testPrintingExercise3_10b() {
        var lst : List<Double> = listOps.apply([1.0,2.0,3.0,4.0])
        let result3 = listOps.foldLeftPrinting(lst, b:1.0)(f: {
            b,a in
            b+a
        })

        println("Fold left iterative + 1 = \(result3)")
    }
    
    func testPrintingFoldRightExercise3_10b() {
        var lst : List<Double> = listOps.apply([1.0,2.0,3.0,4.0])
        let result3 = listOps.foldRightPrinting(lst, b:1.0)(f: {
            b,a in
            b+a
        })
        
        println("Fold right iterative + 1 = \(result3)")
        
        let result = listOps.foldRightPrinting(lst, b:List<Double>())(f: {println("Create List<Double>(head:\($0), tail:\($1))");return List<Double>(head:$0,tail:$1)})
        println("Fold right iterative copy = \(result)")
    }
    
    // Page 43
    func testExercise3_23() {
        let lst1 : List<Int> = listOps.apply([1,2,3])
        let lst2 : List<Int> = listOps.apply([4,5,6])
        let result = listOps.zipWith(lst1,lst2:lst2,f:{$0+$1})
        println(result)
    }
    
    func testOperator() {
        var lst : List<Double> = [1.0,2.0] & [3.0,4.0,5.0]
        println(lst)
        var lst2 : List<Double> = 1.0 & 2.0 & 3.0 & 4.0
        println(lst2)
        var (head,tail) = ~lst
        println(head)
        println(tail)
    }
    
    func testList2() {
        let empty = Cons<String>.Empty
        let node : Cons<String> = Cons.Node("a", empty)
        switch node {
        case .Empty: println("empty")
        case let .Node(head,tail): println("head \(head) tail \(tail)")
        }
    }
}
