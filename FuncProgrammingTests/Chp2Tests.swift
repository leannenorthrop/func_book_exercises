//
//  Chp2Tests.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 03/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
//

import XCTest

class Chp2Tests: XCTestCase {

    func testFactorialReturns1ForEndCase() {
        XCTAssertEqual(1, factorial(0))
    }
    
    func testFactorial() {
        XCTAssertEqual(6, factorial(3))
    }

}
