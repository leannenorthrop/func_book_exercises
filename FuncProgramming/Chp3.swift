//
//  Chp3.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 03/07/2015.
//
//  Interesting discussion on currying
// http://programmers.stackexchange.com/questions/185585/what-is-the-advantage-of-currying

import Foundation

//***************************************************************************************
// Listing 3.1
class List<A> : Printable {
    let head:A?
    let tail:List<A>?
    var description :String {
        var loop : List<A>->String = { _ in return ""}
        loop = {
            lst in
            var str = "unknown, "
            if let v = lst.head as? Printable {
                str = v.description + ", "
            }
            return lst.isEmpty ? "" : str + loop(lst.tail!)
        }
        return loop(self)
    }
    
    var isEmpty : Bool {
        return self.head == nil && self.tail == nil
    }
    
    init() {
        self.head = nil
        self.tail = nil
    }

    convenience init(head:A){
        self.init(head:head, tail: List<A>())
    }
    
    init(head:A, tail:List<A>){
        self.head = head
        self.tail = tail
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
    
    func tuple() -> (A?, List<A>?) {
        return (head,tail)
    }
    
    /// Exercise 3.2: Drop first item from list
    /// :returns tail of list
    func tail2() -> List<A>? {
        return self.tail
    }
    
    /// Exercise 3.3 Replace value at start of list with new value
    /// :returns: New list
    func setHead(item:A) -> List<A> {
        return tail == nil ? List<A>(head:item,tail:List<A>()) : List<A>(head:item,tail:self.tail!)
    }
}

struct ListHelpers {
    func sum(ints:List<Int>?) -> Int {
        let (head,tail) = ints!.tuple()
        switch (head,tail) {
        case(nil,nil): return 0
        case(let head, let tail) : return head! + sum(tail)
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
    
    func product(floats:List<Float>?) -> Float {
        let (head,tail) = floats!.tuple()
        switch (head,tail) {
        case(nil,nil): return Float(1.0)
        case(let head, let tail) : return head! * product(tail)
        }
    }
    
    /// Exercise 3.4 Drop the first n head items from the list
    func drop<A>(l:List<A>, n:Int) -> List<A> {
        return n == 0 || l.isEmpty ? l : drop(l.tail!,n:n-1)
    }
    
    /// Exercise 3.5 Drop the head items from the list while f returns true
    /// :returns: New list
    func drop<A>(l: List<A>, f: A -> Bool) -> List<A> {
        return l.isEmpty ? l : (f(l.head!)  ? drop(l.tail!, f:f) : l)
    }
    
    /// Exercise 3.6
    func head2<A>(l:List<A>) -> List<A> {
        let (head,tail) = l.tuple()
        return l.isEmpty ? List<A>() : (tail!.isEmpty ? List<A>() : List<A>(head:head!, tail:head2(tail!)))
    }
    
    /// Curried drop  the head items from the list while f returns true
    /// :returns: New list
    func drop<A>(l: List<A>)(f: A -> Bool) -> List<A> {
        if f(l.head!) {
            return drop(l.tail!)(f:f)
        } else {
            return l
        }
    }

}
//***************************************************************************************