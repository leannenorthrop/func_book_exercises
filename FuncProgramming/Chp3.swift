//
//  Chp3.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 03/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
//

import Foundation

//***************************************************************************************
// Listing 3.1
class List<A> {
    let head:A?
    let tail:List<A>?
    
    var isEmpty : Bool {
        return self.head == nil && self.tail == nil
    }
    
    init() {
        self.head = nil
        self.tail = nil
    }

    init(head:A, tail:List<A>?){
        self.head = head
        self.tail = tail
    }
    
    init(arr:[A]){
        var a = arr
        let head = a.removeAtIndex(0)
        var tail : [A] = a
        
        self.head = head
        self.tail = tail.isEmpty ? nil : List<A>(arr:tail)
    }
    
    init(arr:A...){
        var a = arr
        let head = a.removeAtIndex(0)
        var tail : [A] = a
        
        self.head = head
        self.tail = tail.isEmpty ? nil : List<A>(arr:tail)
    }
    
    subscript(index: Int) -> A? {
        var loop : Int -> A? = { _ in return nil }
        loop = {
            idx in
            if self.isEmpty {
                return nil
            } else {
                return idx == 0 ? self.head : self.tail![idx-1]
            }
        }
        return loop(index)
    }
}

struct ListHelpers {
    func sum(ints:List<Int>?) -> Int {
        if ints == nil {
            return 0
        } else {
            var lst = ints!
            return lst.tail == nil ? lst.head! : lst.head! + sum(lst.tail)
        }
    }
    
    func apply<A>(arr:[A]) -> List<A> {
        var a = arr
        if a.isEmpty {
            return List<A>()
        } else {
            let head = arr[0]
            var tail:[A]
            switch arr.count {
            case 1 : tail = []
            case 2 : tail = [arr[1]]
            default : tail = Array(arr[1..<arr.count])
            }

            return List<A>(head:head, tail: apply(tail))
        }
    }
    
    func product(ds:List<Float>?) -> Float {
        if ds == nil {
            return Float(1.0)
        } else if ds!.isEmpty {
            return Float(1.0)
        } else if ds!.head == Float(0.0) {
            return Float(0.0)
        } else {
            return ds!.head! * product(ds!.tail)
        }
    }
}
//***************************************************************************************