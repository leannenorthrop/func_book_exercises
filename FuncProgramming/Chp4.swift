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

func traverseInefficient<A,B>(a:List<A>,f: A-> Option<B>) -> Option<List<B>> {
    let lst = ListHelpers().map(a)(f:{f($0)})
    return sequence(lst)
}

func traverse<A,B>(a:List<A>,f:A->Option<B>) -> Option<List<B>> {
    let (head,tail) = a.tuple()
    switch (head,tail) {
    case (nil,nil): return Option<List<B>>.Some(some:List<B>())
                     //map2(Option<B>, Option<List<B>>){new node}
    case (_,_): return map2(f(head!), traverse(tail!,f)){List<B>(head:$0,tail:$1)}
    }
}

/// This is a workaround-wrapper class for a bug in the Swift compiler. DO NOT USE THIS CLASS!!
/// http://owensd.io/2014/07/09/error-handling.html
public class FailableValueWrapper<T> {
    public let value: T
    public init(_ value: T) { self.value = value }
}

public enum Either<A> {
    case Right(FailableValueWrapper<A>)
    case Left(String)
    
    public init(_ value: A) {
        self = .Right(FailableValueWrapper(value))
    }
    
    public init(_ error: String) {
        self = .Left(error)
    }
    
    public var failed: Bool {
        switch self {
        case .Left(let error):
            return true
            
        default:
            return false
        }
    }
    
    public var error: String? {
        switch self {
        case .Left(let error):
            return error
            
        default:
            return nil
        }
    }
    
    public var value: A? {
        switch self {
        case .Right(let wrapper):
            return wrapper.value
            
        default:
            return nil
        }
    }
    
    func map<B>(f: A->B) -> Either<B> {
        switch self {
        case Left: return .Left("Map failed")
        case Right(let v):
            let b:B = f(v.value)
            return Either<B>.Right(FailableValueWrapper<B>(b))
        }
    }
    
    func flatMap<B>(f: (A) -> Either<B>) -> Either<B> {
        switch self {
        case Left: return Either<B>.Left("")
        case Right(let v):
            return f(v.value)
        }
    }
    
    func orElse(def:Either<A>) -> Either<A> {
        switch self {
        case Left: return def
        case Right:return self
        }
    }
    
    func map2<B,C>(b:Either<B>,f:(A,B)->C) -> Either<C> {
        return self.flatMap{aa in b.map { bb in f(aa,bb) }}
    }
}

func mean2(xs: List<Double>) -> Either<Double> {
    if xs.isEmpty {
        return Either.Left("Mean of empty list not possible.")
    } else {
        let sum = ListHelpers().foldLeft(xs, b: Double(0)){
            (acc:Double,d:Double) -> Double in
            acc+d
        }
        let total = Double(ListHelpers().length(xs))
        return Either.Right(FailableValueWrapper<Double>(sum/total))
    }
}

func sequence<A>(a:List<Either<A>>) -> Either<List<A>> {
    let (head,tail) = a.tuple()
    switch (head,tail) {
    case (nil,nil): return Either<List<A>>.Right(FailableValueWrapper<List<A>>(List<A>()))
    case (_,_): return head!.flatMap{aa in sequence(tail!).map{List<A>(head:aa, tail: $0)}}
    }
}

func traverseInefficient<A,B>(a:List<A>,f: A-> Either<B>) -> Either<List<B>> {
    let lst = ListHelpers().map(a)(f:{f($0)})
    return sequence(lst)
}