///
///  Chp2.swift
///  FuncProgramming
///
///  Created by Leanne Northrop on 03/07/2015.
///

import Foundation

/// Computes factorial of a given integer, n
func factorial(n:Int) -> Int {
    // bug in Swift give inner function a no-op definition
    // fix from http://stackoverflow.com/questions/24270693/nested-recursive-function-in-swift
    var loop: (Int,Int) -> Int = { _,_ in return 0}
    loop = {
        n,acc in
        return n <= 0 ? acc : loop(n-1,n*acc)
    }
    return loop(n,1)
}