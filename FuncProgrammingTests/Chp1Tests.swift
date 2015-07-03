//
//  FuncProgrammingTests.swift
//  FuncProgrammingTests
//
//  Created by Leanne Northrop on 03/07/2015.
//

import XCTest

class Chap1Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// Test array initialization via range sequence map
    func testMapFunc() {
        let n:Int = 10
        let squares = Array(map(1..<n) { $0 * $0 })
        print(squares)
    }
    
    /// Test array initialization of coffee/charge tuples via lazy
    func testLazyFunc() {
        let cafe = Cafe()
        let coffees = Array(lazy(0..<10).map({ _ -> (Coffee,Charge) in cafe.buyCoffee(CreditCard(number: "1234-5678-90987")) }))
        print(coffees)
    }
    
    /// Test array initialization of coffee/charge tuples
    func testArrayInitWithoutLazy() {
        let cafe = Cafe()
        let coffees = Array((0..<10).map({ _ -> (Coffee,Charge) in cafe.buyCoffee(CreditCard(number: "1234-5678-90987")) }))
        print(coffees)
    }
    
    /// Purchase 10 coffees from the coffee cafe
    func testChp1BuyCoffees() {
        let purchase : (coffees: [Coffee], charge: Charge) = Cafe().buyCoffees(CreditCard(number: "1234-5678-90987"), n: 10)
        XCTAssertEqual(10, purchase.coffees.count)
        XCTAssertEqual("32.0", purchase.charge.amount.description)
    }
    
    /// Test coalesce charges function
    func testCoalesce() {
        let cc1 = CreditCard(number: "123")
        let cc2 = CreditCard(number: "456")
        let charges1 = Array((0..<4).map({_ -> Charge in Charge(cc: cc1, amount: 1.0) }))
        let charges2 = [Charge(cc: cc2, amount: 3.2), Charge(cc: cc2, amount: 4.5)]
        let charges3 = Array((0..<6).map({_ -> Charge in Charge(cc: cc1, amount: 0.5) }))
        let charges = charges1 + charges2 + charges3
        
        let combinedCharges = coalesce(charges)
        XCTAssertEqual("7.7", combinedCharges[0].amount.description)
        XCTAssertEqual("7.0", combinedCharges[1].amount.description)
    }
}
