//
//  Chp5.swift
//  Example and exercise code from 'Functional Programming in Scala' in Swift.
//
//  Created by Leanne Northrop on 09/07/2015.
//

import Foundation

class LazyVal<A> {
    var thunk : () -> A
    lazy var value:A = self.thunk()
    
    init(_ a:()->A) {
        thunk = a
    }
}

class Stream<A> {
    var headThunk : () -> A?
    var tailThunk : () -> Stream<A>?
    lazy var head:A? = self.headThunk()
    lazy var tail:Stream<A>? = self.tailThunk()
    
    var isEmpty : Bool {
        return self.head == nil
    }
    
    convenience init() {
        self.init({nil})
    }

    convenience init(_ head:() -> A?){
        self.init(head, {Stream<A>()})
    }
    
    init(_ head:() -> A?, _ tail: () -> Stream<A>?){
        self.headThunk = head
        self.tailThunk = tail
    }
    
    init(_ head:() -> A?, _ tail: Stream<A>){
        self.headThunk = head
        self.tailThunk = {tail}
    }
    
    func tuple() -> (() -> A?, () -> Stream<A>?) {
        return (headThunk,tailThunk)
    }
    
    func headOption() -> Option<A> {
        if self.isEmpty {
            return Option<A>.None
        } else {
            return Option<A>.Some(some:self.head!)
        }
    }
    
    func toList() -> List<A> {
        return self.head == nil ? List<A>() : List<A>(head: self.head!, tail: tail!.toList())
    }
    
    func take(n:Int) -> Stream<A> {
        // a bit odd evaluating tail but as it doesn't evaluate tail's first element
        // should be ok.
        return n == 0 ? Stream<A>() : Stream<A>(self.headThunk, self.tail!.take(n-1))
    }
    
    func drop(n:Int) -> Stream<A> {
        if self.head == nil {
            return Stream<A>()
        } else if n == 0 {
            return Stream<A>(self.headThunk,self.tailThunk)
        } else {
            return self.tail!.drop(n-1)
        }
    }
    
    func takeWhile(p: A -> Bool) -> Stream<A> {
        return self.isEmpty ? Stream<A>() : (p(self.head!) ? Stream<A>(self.headThunk, self.tail!.takeWhile(p)) : Stream<A>())
    }
    
    func exists(p: A ->Bool) -> Bool {
        return self.isEmpty ? false : p(self.head!) || self.tail!.exists(p)
    }
    
    func foldRight<B>(z: () -> B, _ f: (A, ()->B) -> B) -> B {
        if self.isEmpty {
            return z()
        } else {
            return f(self.head!, {self.tail!.foldRight(z, f)})
        }
    }
    
    func exists2(p: A ->Bool) -> Bool {
        return self.foldRight({false},{a, b in p(a) || b()})
    }
    
    func forAll(p: A ->Bool) -> Bool {
        return self.foldRight({true},{a, b in p(a) && b()})
    }
    
    func takeWhile2(p: A ->Bool) -> Stream<A> {
        return self.foldRight({Stream<A>()},{
            head, tail in
            return p(head) ? Stream<A>({head},tail) : Stream<A>()
        })
    }
    
    func headOption2() -> Option<Stream<A>> {
        return self.foldRight({Option<Stream<A>>.None},{
            a, b in
            return Option<Stream<A>>.Some(some:Stream<A>({a}))
        })
    }
    
    func map<B>(f: A->B) -> Stream<B> {
        return self.foldRight({Stream<B>()},{
            head, tail in
            return Stream<B>({f(head)},tail)
        })
    }
    
    func filter(f:A->Bool)->Stream<A> {
        return self.foldRight({Stream<A>()},{
            head, tail in
            if f(head) {
                let h : () -> A? = {head}
                let t : () -> Stream<A>? = tail
                return Stream<A>(h,t)
            } else {
                return tail()
            }
        })
    }
    
    func append(a: () -> A?) -> Stream<A> {
        return self.foldRight({Stream<A>(a)},{
            head, tail in
            let h : () -> A? = {head}
            let t : () -> Stream<A>? = tail
            return Stream<A>(h,t)
        })
    }
    
    func append(a: Stream<A>) -> Stream<A> {
        return self.foldRight({a},{
            head, tail in
            let h : () -> A? = {head}
            let t : () -> Stream<A>? = tail
            return Stream<A>(h,t)
        })
    }
    
    func append(a: () -> Stream<A>) -> Stream<A> {
        return self.foldRight(a,{
            head, tail in
            let h : () -> A? = {head}
            let t : () -> Stream<A>? = tail
            return Stream<A>(h,t)
        })
    }
    
    func flatMap<B>(f: A->Stream<B>) -> Stream<B> {
        return self.foldRight({Stream<B>()}, {
            head, tail in
            return f(head).append(tail)
        })
    }
    
    func find(p: A -> Bool) -> Option<A> {
        return self.filter(p).headOption()
    }
    
    func take2(n:Int) -> Stream<A> {
        return unfold((self,n),{
            s in
            if s.0.isEmpty {
                return Option<(A, (Stream<A>,Int))>.None
            } else if s.1 == 1 {
                return Option<(A, (Stream<A>,Int))>.Some(some: (s.0.head!, (Stream<A>(),0)))
            } else {
                return Option<(A, (Stream<A>,Int))>.Some(some: (s.0.head!, (s.0.tail!,s.1-1)))
            }
        })
    }
    
    func takeWhile3(p: A -> Bool) -> Stream<A> {
        return unfold(self,{
            s in
            if s.0.isEmpty || !p(s.0.head!){
                return Option<(A, Stream<A>)>.None
            } else {
                return Option<(A, Stream<A>)>.Some(some: (s.0.head!, s.0.tail!))
            }
        })
    }
    
    func map2<B>(f: A->B) -> Stream<B> {
        return unfold(self,{
            s in
            if s.0.isEmpty {
                return Option<(B, Stream<A>)>.None
            } else {
                return Option<(B, Stream<A>)>.Some(some: (f(s.0.head!), s.0.tail!))
            }
        })
    }
    
    func zipWith(lst:Stream<A>,f:(A,A)->A) -> Stream<A> {
        return unfold((self,lst),{
            s in
            if s.0.isEmpty || s.1.isEmpty {
                return Option<(A, (Stream<A>,Stream<A>))>.None
            } else {
                return Option<(A, (Stream<A>,Stream<A>))>.Some(some: (f(s.0.head!,s.1.head!), (s.0.tail!,s.1.tail!)))
            }
        })
    }
    
    // Not sure about the safety of this function
    func zipAll<B>(lst:Stream<B>) -> Stream<(Option<A>,Option<B>)> {
        return unfold((self,lst),{
            s in
            if s.0.isEmpty && s.1.isEmpty {
                return Option<((Option<A>,Option<B>), (Stream<A>,Stream<B>))>.None
            } else if s.0.isEmpty {
                return Option<((Option<A>,Option<B>), (Stream<A>,Stream<B>))>.Some(some: ((Option<A>.None,Option<B>.Some(some: s.1.head!)), (s.0, s.1.tail!)))
            } else if s.1.isEmpty {
                return Option<((Option<A>,Option<B>), (Stream<A>,Stream<B>))>.Some(some: ((Option<A>.Some(some: s.0.head!),Option<B>.None), (s.0, s.1.tail!)))
            } else {
                return Option<((Option<A>,Option<B>), (Stream<A>,Stream<B>))>.Some(some: ((Option<A>.Some(some: s.0.head!),Option<B>.Some(some: s.1.head!)), (s.0, s.1.tail!)))
            }
        })
    }
    
    func tails() -> Stream<Stream<A>> {
        return unfold(self) {
            s in
            if s.isEmpty {
                return Option<(Stream<A>, Stream<A>)>.None
            } else {
                return Option<(Stream<A>, Stream<A>)>.Some(some:(s, s.drop(1)))
            }
        }.append(Stream<Stream<A>>())
    }
}

func apply<A>(arr:[() -> A?]) -> Stream<A> {
    var a = arr
    if a.isEmpty {
        return Stream<A>()
    } else {
        let head = arr[0]
        var tail:[() ->A?]
        switch arr.count {
        case 1 : tail = []
        case 2 : tail = [arr[1]]
        default : tail = Array(arr[1..<arr.count])
        }
        
        return Stream<A>(head, {apply(tail)})
    }
}

func constant<A>(a:A)->Stream<A> {
    return Stream<A>({a},{constant(a)})
}

func from(n:Int)->Stream<Int> {
    return Stream<Int>({n},{from(n+1)})
}

func fib(n:Int)->Stream<Int> {
    var loop: (Int,Int) -> Stream<Int> = { _, _ in return Stream<Int>({0})}
    loop = {
        a,b in
        return Stream<Int>({a},{loop(b,a+b)})
    }
    return loop(0,1)
}

func unfold<A,S>(z:S, f: S->Option<(A,S)>) -> Stream<A> {
    switch f(z) {
    case .None: return Stream<A>()
    case .Some(let t): return Stream<A>({t.0},{unfold(t.1,f)})
    }
}

func from2(n:Int)->Stream<Int> {
    return unfold(n,{
        s in
        Option<(Int,Int)>.Some(some: (s,s+1))
    })
}

func constant2(n:Int)->Stream<Int> {
    return unfold(n,{
        s in
        Option<(Int,Int)>.Some(some: (s,s))
    })
}

func ones2()->Stream<Int> {
    return unfold(1,{
        s in
        Option<(Int,Int)>.Some(some: (s,s))
    })
}

func startsWith(s1:Stream<Int>,s2:Stream<Int>) -> Bool {
    if s2.isEmpty {
        return true
    } else if s1.isEmpty {
        return false
    } else if s1.head! == s2.head! {
        return true && startsWith(s1.tail!,s2.tail!)
    } else {
        return false
    }
}

func hasSubsequence(s1: Stream<Int>, s2: Stream<Int>) -> Bool {
    return s1.tails().exists{startsWith($0, s2)}
}
