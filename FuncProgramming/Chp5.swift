//
//  Chp5.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 09/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
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