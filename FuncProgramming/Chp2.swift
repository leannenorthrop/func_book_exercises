///
///  Chp2.swift
///  FuncProgramming
///
///  Created by Leanne Northrop on 03/07/2015.
///

import Foundation

/// Computes absolute value of a number
func abs(n:Int) -> Int {
    return n < 0 ? -n : n
}

/// Computes factorial of a given integer, n
/// :param: Number to calculate factorial on
/// :returns: Factorial of `n`
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
    var loop: Int -> Int = { _ in return 0}
    loop = {
        n in
        return n <= 0 ? 0 : n == 1 ? 1 : loop(n-2)+loop(n-1)
    }
    return loop(n-1)
}

/// Simple struct to contain Listing 2.2 examples
struct Listing2_2 {
    func formatAbs(x:Int) -> String {
        return "The absolute value of \(x) is \(abs(x))"
    }
    func formatFactorial(x:Int) -> String {
        return "The factorial value of \(x) is \(factorial(x))"
    }
}

/// Simple struct to contain Listing 2.2 examples replaced by HOF
struct Listing2_2_HigherOrderFunction {
    func formatResult(name:String, n: Int, f: Int -> Int) -> String {
        return "The \(name) value of \(n) is \(f(n))"
    }
}

/// Generic / polymorphic higher order function
func findFirst<A>(arr: [A], p : A -> Bool) -> Int {
    var loop: Int -> Int = { _ in return 0}
    loop = {
        n in
        // unlike dup strings below this loop counts up
        return n >= arr.count ? -1 : p(arr[n]) ? n : loop(n+1)
    }
    return loop(0)
}

/// Exercise 2.2 implementation of hof which checks if an array is sorted
/// according to the given function, ordered
/// :param: Array to check sort order
/// :param: Function that compares two A's returning true if first
/// A is in the correct position compared to second A
/// :returns: true if array is sorted, false otherwise
func isSorted<A>(arr:[A], ordered: (A,A) -> Bool) -> Bool {
    var loop: Int -> Bool = { _ in return false}
    loop = {
        idx in
        return idx >= arr.count ? true : ordered(arr[idx-1], arr[idx]) && loop(idx+1)
    }
    return loop(1)
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