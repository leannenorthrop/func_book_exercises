///
///  Chp2.swift
///  Example and exercise code from 'Functional Programming in Scala' in Swift.
///
///  Created by Leanne Northrop on 03/07/2015.
///
/// Figured out exercises on my own but a nice post describing currying can be
/// found at:
///  https://robots.thoughtbot.com/introduction-to-function-currying-in-swift
/// Other useful:
/// https://www.weheartswift.com/higher-order-functions-map-filter-reduce-and-more/
/// http://blog.scottlogic.com/2014/06/26/swift-sequences.html

import Foundation

/// Computes absolute value of a number. Page 15
func abs(n:Int) -> Int {
    return n < 0 ? -n : n
}

/// Computes factorial of a given integer, n. Page 20
///
/// :param: `n` Number to calculate factorial on
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

// Exercise 1.2 page 21
/// Computes Fibonacci number
///
/// :param: `n`
/// :returns: nth number of Fibonacci sequence
func fib(n:Int) -> Int {
    var loop: Int -> Int = { _ in return 0}
    loop = {
        n in
        return n <= 0 ? 0 : n == 1 ? 1 : loop(n-2)+loop(n-1)
    }
    return loop(n-1)
}

/// Simple struct to contain Listing 2.2 examples. page 21
struct Listing2_2 {
    /// Format absolute
    ///
    /// :param: `x` value to calculate abs on
    /// :returns: String describing absolute value of given param
    func formatAbs(x:Int) -> String {
        return "The absolute value of \(x) is \(abs(x))"
    }
    
    /// Format absolute
    ///
    /// :param: `x` value to calculate factorial on
    /// :returns: String describing factorial value of given param
    func formatFactorial(x:Int) -> String {
        return "The factorial value of \(x) is \(factorial(x))"
    }
}

/// Simple struct to contain Listing 2.2 examples replaced by HOF page 22.
struct Listing2_2_HigherOrderFunction {
    /// Format result
    ///
    /// :param: name    of function
    /// :param: n       value to use for calcuation
    /// :param: f       calculation function
    /// :returns: String describing value of given param and calculated value
    func formatResult(name:String, n: Int, f: Int -> Int) -> String {
        return "The \(name) value of \(n) is \(f(n))"
    }
}

// page 23
// Generic / polymorphic higher order function 
/// First the first item in the given array that satisfies some property
///
/// :param: arr     to search
/// :param: p   function that returns true if some property holds
/// :returns: Array index of the first value that has the property
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
/// according to the given function, ordered. page 24.
///
/// :param: arr     to check sort order
/// :param: ordered Function that compares two A's returning true if first A is in the correct position compared to second A
/// :returns: true if array is sorted, false otherwise
func isSorted<A>(arr:[A], ordered: (A,A) -> Bool) -> Bool {
    var loop: Int -> Bool = { _ in return false}
    loop = {
        idx in
        return idx >= arr.count ? true : ordered(arr[idx-1], arr[idx]) && loop(idx+1)
    }
    return loop(1)
}

/// page 26. Partially applied function
///
/// :param: a   value to partially apply
/// :param: f   function to partially apply
/// :returns: function
func partial1<A,B,C>(a: A, f:(A,B)->C) -> B -> C {
    return {f(a,$0)}
}

/// page 26. Partially applied function. Dual parameter list syntax
///
/// :param: a   value to partially apply
/// :param: f   function to partially apply
/// :returns: function
func partial2<A,B,C>(a: A, f:(A,B)->C)(b:B) -> C {
    return {f(a,$0)}(b)
}

/// Exercise 2.3
/// Convert function that takes two parameters and return a chain
/// of functions that take one parameter each
///
/// :param: f   function that takes two parameters
/// :returns: function chain taking each parameter separately
func curry<A,B,C>(f: (A,B)->C) -> A -> (B -> C) {
    return { a in { b in f(a, b) } }
}

/// Exercise 2.4
///
func uncurry<A,B,C>(f: A -> B -> C) -> (A,B) -> C {
    return {
        a, b -> C in
        return f(a)(b)
    }
}

/// Exercise 2.5
func compose<A,B,C>(f: B -> C, g: A ->B) -> A -> C {
    return {f(g($0))}
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