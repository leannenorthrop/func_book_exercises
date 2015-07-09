//
//  Chp4.swift
//  Example and exercise code from 'Functional Programming in Scala' in Swift.
//
//  Created by Leanne Northrop on 07/07/2015.
//

import Foundation

enum Option<A> : NilLiteralConvertible {
    case None
    case Some(some:A)
    
    /// Construct a `nil` instance.
    init() {
        self = None
    }
    
    /// Construct a non-\ `nil` instance that stores `some`.
    init(some: A) {
        self = Some(some:some)
    }
    
    init(nilLiteral: ())
    {
        self = None
    }
    
    func map<B>(f: (A) -> B) -> Option<B> {
        switch self {
        case None: return Option<B>()
        case let Some(v):
            let b:B = f(v)
            return Option<B>(some:b)
        }
    }
    
    func flatMap<B>(f: (A) -> Option<B>) -> Option<B> {
        switch self {
        case None: return Option<B>()
        case let Some(v):
            return f(v)
        }
    }
    
    /// Indicating sub-types not possible yet in Swift 1.2?
    func getOrElse(def:A) -> A {
        switch self {
        case None: return def
        case let Some(v):return v
        }
    }
    
    func orElse(def:Option<A>) -> Option<A> {
        switch self {
        case None: return def
        case let Some(v):return self
        }
    }
    
    func filter(f: (A) -> Bool) -> Option<A> {
        switch self {
        case None: return nil
        case let Some(v):return f(v) ? self : nil
        }
    }
}

class Employee {
    let name : String
    let department : String
    init(n:String,d:String) {
        self.name = n
        self.department = d
    }
}

func lookupByName(name:String) -> Option<Employee> {
    if name == "Leanne" {
        return Option<Employee>(some:Employee(n:"Leanne",d:"IT"))
    } else {
        return Option<Employee>()
    }
}

func mean(xs: List<Double>) -> Option<Double> {
    if xs.isEmpty {
        return Option.None
    }
    else {
        let sum = ListHelpers().foldLeft(xs, b: Double(0)){
            (acc:Double,d:Double) -> Double in
            acc+d
        }
        let total = Double(ListHelpers().length(xs))
        return Option.Some(some: sum/total)
    }
}

func variance(xs: List<Double>) -> Option<Double> {
    return mean(xs).flatMap{m in mean(ListHelpers().map(xs)(f:{x in pow(x-m,2)}))}
}

func map2<A,B,C>(a: Option<A>, b: Option<B>, f: (A,B)->C) -> Option<C> {
    return a.flatMap{aa in b.map{bb in f(aa,bb)}}
}

func map3<A,B,C,D>(a: Option<A>, b: Option<B>, c: Option<C>, f: (A,B,C)->D) -> Option<D> {
    return a.flatMap{aa in b.flatMap{bb in c.map{cc in f(aa,bb,cc)}}}
}

func try<A>(a: () -> A?) -> Option<A> {
    // no try-catch in Swift 1.2 so the below is a bit stupid
    var aa : A? = a()
    if aa == nil {
        return Option<A>.None
    } else {
        return Option<A>.Some(some:aa!)
    }
}

func insuranceRateQuote(age:Int, tickets:Int)->Double {
    return Double(age*tickets)
}

func parseInsuranceRateQuote(age: String,
    noOfSpeedingTickets: String) -> Option<Double> {
        let optAge : Option<Int> = try({age.toInt()})
        let optTickets : Option<Int> = try({noOfSpeedingTickets.toInt()})
    return map2(optAge,optTickets,insuranceRateQuote)
}

func sequence<A>(a:List<Option<A>>) -> Option<List<A>> {
    let (head,tail) = a.tuple()
    switch (head,tail) {
    case (nil,nil): return Option<List<A>>.Some(some:List<A>())
    case (_,_): return head!.flatMap{aa in sequence(tail!).map{List<A>(head:aa, tail: $0)}}
    }
}

