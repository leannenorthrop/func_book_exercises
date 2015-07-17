//
//  Chp6Tests.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 10/07/2015.
//

import XCTest

class Chp6Tests: XCTestCase {

    // Page 81
    func testRNG() {
        let rng1 = SimpleRNG(5).nextInt()
        let rng2 = SimpleRNG(5).nextInt()
        XCTAssertEqual(rng1.0, rng2.0)
        let rng = SimpleRNG(5)
        let rng3 = rng.nextInt()
        let rng4 = rng.nextInt()
        XCTAssertEqual(rng3.0, rng4.0)
    }

    // Page 82
    func testExercise6_1() {
        let rng = SimpleRNG(5)
        let r = nonNegativeInt(rng)
        XCTAssertTrue(r.0 > 0)
    }
    
    // Page 83
    func testExercise6_2() {
        let rng = SimpleRNG(5)
        let r = double(rng)
        XCTAssertTrue(r.0 > Double(0) && r.0 <= Double(1))
    }
    
    // Page 83
    func testExercise6_4() {
        let rng = SimpleRNG(89)
        let r = ints(100,rng)
        XCTAssertEqual(92,r.0.head!)
    }
    
    // Page 84
    func testNonNegEven() {
        let r = nonNegEven()
        println(r(SimpleRNG(5)))
    }
    
    // Page 85
    func testDouble2() {
        let r = double2(SimpleRNG(5))
        XCTAssertEqual(0.00625,r.0)
    }
    
    // Page 85 - TODO it bothers me that you can't use mapRng2(f1,f2)
    // might raise a bug report for compiler
    func testMap2() {
        let f1 = nonNegEven()
        let f2 = double4
        let map = mapRng2(f1,f1) { return ($0+$1).description}
        let r = map(SimpleRNG(5))
        println(r.0)
    }
    
    // Page 86
    func testSequence() {
        let f1 = nonNegEven()
        var lst = ListHelpers().apply([f1,f1,f1])
        
        let f = actionSequence(lst)
        let (list,rng) = f(SimpleRNG(5))
        
        let r1 = SimpleRNG(5).nextInt()
        let r2 = r1.1.nextInt()
        let r3 = r2.1.nextInt()
        XCTAssertEqual(list[0]!, r1.0)
        XCTAssertEqual(list[1]!, r2.0)
        XCTAssertEqual(list[2]!, r3.0)
        let r4 : SimpleRNG = rng as! SimpleRNG
        let r5 : SimpleRNG = r3.1 as! SimpleRNG
        XCTAssertEqual(r4.seed, r5.seed)
    }
    
    // Page 86
    func testIntsViaSequence() {
        let (list,rng) = intsViaSequence(3,SimpleRNG(5))
        
        let r1 = SimpleRNG(5).nextInt()
        let r2 = r1.1.nextInt()
        let r3 = r2.1.nextInt()
        XCTAssertEqual(list[0]!, r1.0)
        XCTAssertEqual(list[1]!, r2.0)
        XCTAssertEqual(list[2]!, r3.0)
        let r4 : SimpleRNG = rng as! SimpleRNG
        let r5 : SimpleRNG = r3.1 as! SimpleRNG
        XCTAssertEqual(r4.seed, r5.seed)
    }
    
    func testFlatMap() {
        let f = flatMapRng(nonNegEven(),{
            (a:Int) -> RNG -> (Double,RNG) in
            let b = 1.0/Double(a)
            return {
                rng in
                return (b,rng)
            }
        })
        
        let (b,rng) = f(SimpleRNG(5))

        let f2 = flatMapRng(nonNegativeInt2,{
            (a:Int) -> RNG -> (Double,RNG) in
            let b = 1.0/Double(a)
            return {
                rng in
                return (b,rng)
            }
        })
    }
    
    func testState() {
        let state = State(nonNegEven())
        let (a,s) = state.run(SimpleRNG(5))
        let state2 = state.map{1.0/Double($0)}
        let (a2,s2) = state2.run(SimpleRNG(5))
    }
}
