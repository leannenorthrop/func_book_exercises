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

// Exercise 1.2
/// Computes Fibonacci number 
func fib(n:Int) -> Int {
    var loop: (Int) -> Int = { _ in return 0}
    loop = {
        n in
        return n <= 0 ? 0 : n == 1 ? 1 : loop(n-2)+loop(n-1)
    }
    return loop(n-1)
}













//*****************************************************************************************
//    Playground
//*****************************************************************************************
/// Being curious about for loops
/// :param: Number of duplicates
/// :param: First string
/// :param: Second string
/// :results: First and second string duplicated
func duplicateStrings(n:Int,s1:String,s2:String) -> (String,String) {
    var loop: (Int,String,String) -> (String,String) = {_,_,_ in return ("","")}
    loop = {
        n,str1,str2 in
        // current state of loop is captured in parameters
        // loop counts down instead of imperative for loop which counts up
        return n <= 1 ? (str1,str2) : loop(n-1,s1+str1,s2+str2)
    }
    return loop(n,s1,s2)
}