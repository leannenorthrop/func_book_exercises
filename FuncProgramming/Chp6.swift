//
//  Chp6.swift
//  Example and exercise code from 'Functional Programming in Scala' in Swift.
//
//  Created by Leanne Northrop on 10/07/2015.
//

import Foundation

typealias RandomTuple = (int:Int,rng:RNG)

protocol RNG {
    /// Generate a random int and return along with next RandomNumberGenerator
    ///
    /// :returns: pair tuple of random integer, new RandomNumberGenerator
    func nextInt()->RandomTuple
}

class SimpleRNG : RNG {
    public let seed:Int
    init(_ s:Int) {
        self.seed = s
    }
    
    // Page 81
    /// Generate a random int and return along with next RandomNumberGenerator
    ///
    /// :returns: pair tuple of random integer, new RandomNumberGenerator
    func nextInt() -> RandomTuple {
        let newSeed = (seed * Int(0x5DEECE66D) + Int(0xB)) & Int(0xFFFFFF)
        let nextRNG = SimpleRNG(newSeed)
        let n = Int(newSeed >> 16)
        return (n, nextRNG)
    }
}

// Page 82
/// Generate a random non-negative int and return along with next
/// RandomNumberGenerator
///
/// :returns: pair tuple of non-negative random integer, new RandomNumberGenerator
func nonNegativeInt(rng:RNG) -> RandomTuple {
    let t = rng.nextInt()
    return (t.int < 0 ? -(t.int) : t.int, t.rng)
}

func nonNegativeInt2(_ rng:RNG) -> (Int,RNG) {
    let t = rng.nextInt()
    return (t.int < 0 ? -(t.int) : t.int, t.rng)
}

// Page 83
/// Generate a random non-negative double between 0 and 1 and return along with next
/// RandomNumberGenerator
///
/// :returns: pair tuple of non-negative random double, new RandomNumberGenerator
func double(rng:RNG) -> (d:Double,rng:RNG) {
    let i = rng.nextInt()
    return ((Double(1)/Double(i.0)),i.1)
}

// Page 83
func intDouble(rng:RNG) -> ((Int,Double),RNG) {
    let r1 = rng.nextInt()
    let d1 = double(r1.1)
    return ((r1.0, d1.0), d1.1)
}

// Page 83
func doubleInt(rng:RNG) -> ((Double,Int),RNG) {
    let d1 = double(rng)
    let r1 = d1.1.nextInt()
    return ((d1.0, r1.0), r1.1)
}

// Page 83
func double3(rng:RNG) -> ((Double,Double,Double),RNG) {
    let d1 = double(rng)
    let d2 = double(d1.1)
    let d3 = double(d2.1)
    return ((d1.0, d2.0, d3.0), d3.1)
}

func ints(count:Int,rng:RNG) -> (List<Int>,RNG) {
    if count <= 0 {
        return (List<Int>(),rng)
    } else {
        let r = rng.nextInt()
        let t = ints(count-1,r.1)
        return (List<Int>(head:r.0,tail:t.0),t.1)
    }
}

// Generics mixed with typealias not possible in Swift 1.2 so have to spell it out
// There's probably some workaround possible (TODO)
func unit<A>(a:A) -> RNG -> (A,RNG) {
    return {(a,$0)}
}

/// Page 84 Listing. Map state action from type A to type B.
/// 
/// :param: s   State action
/// :param: f   Conversion function from A to B
/// :returns:   State action yielding B
func map<A,B>(s: RNG->(A,RNG),f:A->B) -> RNG -> (B,RNG) {
    return {
        rng in
        let (a,rng2) = s(rng)
        return (f(a),rng2)
    }
}

func nonNegEven() -> RNG -> (Int,RNG) {
    return map(nonNegativeInt){$0 - $0 % 2}
}

// Page 85
/// Generate a random non-negative double between 0 and 1 and return along with next
/// RandomNumberGenerator
///
/// :returns: pair tuple of non-negative random double, new RandomNumberGenerator
func double2(rng:RNG) -> (Double,RNG) {
    return map(nonNegativeInt){Double(1)/Double($0)}(rng)
}

func double4() -> RNG -> (Double,RNG) {
    return map(nonNegativeInt){Double(1)/Double($0)}
}

func mapRng2<A,B,C>(ra: RNG -> (A,RNG),
                 rb: RNG -> (B,RNG),
                 f: (A,B) -> C) -> RNG -> (C,RNG) {
    return {
        rng in
        let (a,rng2) = ra(rng)
        let (b,rng3) = rb(rng2)
        return (f(a,b),rng3)
    }
}

func actionSequence<A>(fs: List<RNG ->(A,RNG)>) -> RNG -> (List<A>,RNG) {
    return {
        rng in
        ListHelpers().foldLeftIterative(fs, b: (List<A>(),rng), f: {
            t,f in
            let lst = t.0
            let r = t.1
            let (a,nextRng) = f(r)
            return (ListHelpers().append(lst,a:a), nextRng)
        })
    }
}

func intsViaSequence(count:Int,rng:RNG) -> (List<Int>,RNG) {
    if count <= 0 {
        return (List<Int>(),rng)
    } else {
        return actionSequence(ListHelpers().apply((0..<count).map({ _ in nonNegEven()})))(rng)
    }
}

func flatMapRng<A,B>(f:(RNG)->(A,RNG), g:(A)->RNG->(B,RNG)) -> RNG -> (B,RNG) {
    return {
        rng in
        let (a, r1) = f(rng)
        return g(a)(r1)
    }
}

func nonNegativeLessThan(n:Int) -> RNG -> (Int,RNG) {
    return flatMapRng(nonNegativeInt2,{
        (i:Int) -> RNG -> (Int,RNG) in
        let mod = i % n
        if (i + (n-1) - mod >= 0) {
            return unit(mod)
        } else {
            return nonNegativeLessThan(n)
        }
    })
}

func mapInTermsOfFlatMap<A,B>(s: RNG->(A,RNG),f:A->B) -> RNG -> (B,RNG) {
    return flatMapRng(s,{
        (a:A) -> RNG -> (B,RNG) in
        return unit(f(a))
    })
}

func map2InTermsOfFlatMap<A,B,C>(ra: RNG -> (A,RNG),
                                 rb: RNG -> (B,RNG),
                                 f: (A,B) -> C) -> RNG -> (C,RNG) {
    return flatMapRng(ra,{
        (a:A) -> RNG -> (C,RNG) in
        return map(rb){f(a,$0)}
    })
}

struct State<S,A> {
    let transition:S -> (A,S)
    
    init(_ t:(S) -> (A,S)) {
        self.transition = t
    }
    
    func run(s:S) -> (A,S) {
        return transition(s)
    }
    
    func unit(a:A) -> State<S,A> {
        return State({(a,$0)})
    }
    
    func flatMap<B>(f:(A)->State<S,B>) -> State<S,B> {
        return State<S,B>({
            let (a:A, s1:S) = self.run($0)
            return f(a).run(s1)
        })
    }
    
    func map<B>(f:A->B) -> State<S,B> {
        return self.flatMap{
            (a:A) -> State<S,B> in
            State<S,B>({(f(a),$0)})
        }
    }
    
    func map2<B,C>(rb: State<S,B>,
                   f: (A,B) -> C) -> State<S,C> {
            return self.flatMap{
                (a:A) -> State<S,C> in
                return rb.map{f(a,$0)}
            }
    }
    
    func sequence(fs: List<State<S,A>>) -> S -> (List<A>,S) {
        return {
            state in
            ListHelpers().foldLeftIterative(fs, b: (List<A>(),state), f: {
                t,f in
                let lst = t.0
                let s = t.1
                let (a,nextState) = f.run(s)
                return (ListHelpers().append(lst,a:a), nextState)
            })
        }
    }
}

protocol Input {}
struct Coin : Input {}
struct Turn : Input {}

struct Machine {
    let locked:Bool
    let coins:Int
    let candies:Int
    
    init(_ l:Bool,_ co:Int, _ ca:Int) {
        self.locked = l
        self.coins = co
        self.candies = ca
    }

    func tuple() -> (Bool,Int,Int) {
        return (locked,coins,candies)
    }
    
    func simulateMachine(inputs:List<Input>) -> Machine{
        let seq = ListHelpers().map(inputs)(f:{
            (input:Input) -> State<Machine,(Int,Int)> in
            return State<Machine,(Int,Int)>({
                (m:Machine) -> ((Int,Int),Machine) in
                let newM = update(input,m)
                return ((newM.coins,newM.candies),newM)
            })
        })
        let me = self
        let initState = State<Machine,(Int,Int)>({((me.coins,me.candies),$0)})
        let (list,finalMachine) = initState.sequence(seq)(self)
        return finalMachine
    }
}

func update(i:Input,s:Machine) -> Machine  {
    let (i, t) = (i,s.tuple())
    switch (i,t) {
    case (_, (_, 0, _)): return s
    case (is Coin, (false, _, _)): return s
    case (is Turn, (true, _, _)): return s
    case (is Coin, (true, let coin, let candy)):
        return Machine(false, coin + 1,candy)
    case (is Turn, (false, let coin, let candy)):
        return Machine(true, coin,candy - 1)
    default: return s
    }
}