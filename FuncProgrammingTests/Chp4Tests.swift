//
//  Chp4Tests.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 07/07/2015.
//

import XCTest

class Chp4Tests: XCTestCase {

    func testConstructors() {
        let none : Option<Int> = nil
        let some : Option<Int> = Option<Int>(3)
    }

    // Page 54
    func testExercise4_1_Map() {
        let some : Option<Int> = Option<Int>(3)
        let result : Option<Int> = some.map({$0 * 3})
        switch result {
        case .None: XCTAssertTrue(false)
        case let .Some(v):XCTAssertEqual(9,v)
        }
    }
    
    // Page 54
    func testExercise4_1_FlatMap() {
        let some : Option<Int> = Option<Int>(3)
        let result : Option<Int> = some.flatMap({Option<Int>(($0 * 3))})
        switch result {
        case .None: XCTAssertTrue(false)
        case let .Some(v):XCTAssertEqual(9,v)
        }
    }
    
    // Page 54
    func testExercise4_1_GetOrElse() {
        let some : Option<Int> = Option<Int>(3)
        let result = some.getOrElse(4)
        XCTAssertEqual(3,result)
        XCTAssertEqual(4,Option<Int>().getOrElse(4))
    }
    
    // Page 54
    func testExercise4_1_Filter() {
        let some : Option<Int> = Option<Int>(3)
        let result = some.filter({$0 == 4})
        switch result {
        case .None: XCTAssertTrue(true)
        case .Some: XCTAssertTrue(false)
        }
    }
    
    // Page 55
    func testOption() {
        var r1 = lookupByName("Leanne").map({$0.department})
        XCTAssertEqual("IT", r1.getOrElse(""))
        var r2 = lookupByName("Anne").map({$0.department})
        switch r2 {
        case .None: XCTAssertTrue(true)
        default: XCTAssertTrue(false)
        }
        var r3 = lookupByName("Anne").map({$0.department}).filter({$0 != "Accounts"}).getOrElse("Default Dep")
        XCTAssertEqual("Default Dep",r3)
        
    }
    
    func testExercise4_3() {
        func doSomeFantasticThing(a:Int,b:Int)->String {
            return "Something fantastic happened to \(a) and \(b)!"
        }
        
        let result = map2(Option<Int>.Some(some: 3), Option<Int>.Some(some: 5), doSomeFantasticThing).getOrElse("")
        XCTAssertEqual("Something fantastic happened to 3 and 5!", result)
        
        let result2 = map2(Option<Int>.Some(some: 3), Option<Int>.None, doSomeFantasticThing).getOrElse("")
        XCTAssertEqual("", result2)
    }
    
    func testMap3() {
        func join(a:String,b:String,c:String)->String {
            return "\(a)\(b)\(c)"
        }
        
        let opt1 = Option<String>.Some(some: "Hello ")
        let opt2 = Option<String>.Some(some: "there ")
        let opt3 = Option<String>.Some(some: "world!")
        
        let result = map3(opt1,opt2,opt3,join)
        XCTAssertEqual("Hello there world!", result.getOrElse(""))
        
        let result2 = map3(opt1,Option<String>.None,opt3,join).getOrElse("")
        XCTAssertEqual("", result2)
    }
    
    func testInsurance() {
        let result1 = parseInsuranceRateQuote("15", "3")
        XCTAssertEqual(Double(45), result1.getOrElse(Double(0)))
        let result2 = parseInsuranceRateQuote("1a5", "3")
        XCTAssertEqual(Double(0), result2.getOrElse(Double(0)))
    }
    
    func testExercise4_4() {
        let opt1 = Option<String>.Some(some: "Hello ")
        let opt2 = Option<String>.Some(some: "there ")
        let opt3 = Option<String>.Some(some: "world!")
        let lst : List<Option<String>> = ListHelpers().apply([opt1,opt2,opt3])
        let result = sequence(lst)
        switch result {
            case .None: XCTAssertTrue(false)
            case .Some: XCTAssertTrue(true)
        }
    }
}
