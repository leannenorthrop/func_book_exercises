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
// Listings for Chapter 3
class List<A> : Printable {
    let head:A?
    let tail:List<A>?
    var description :String {
        var loop : List<A>->String = { _ in return ""}
        loop = {
            lst in
            var str = "unknown, "
            if let v = lst.head as? Printable {
                str = v.description + (lst.tail!.isEmpty ? "" : ", ")
            }
            return lst.isEmpty ? ")" : str + loop(lst.tail!)
        }
        return "(" + loop(self)
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

    /// Listing 3.2
    func foldRight<A,B>(lst:List<A>, b:B)(f:(A,B)->B)->B {
        let (head,tail) = lst.tuple()
        switch (head,tail) {
        case (nil,nil): return b
        case (let head,let tail): return f(head!, foldRight(tail!, b: b)(f:f))
        }
    }
    
    func sum2(ints:List<Int>) -> Int {
        return foldRight(ints, b: 0)(f:{$0 + $1})
    }
    
    func product2(floats:List<Float>) -> Float {
        return foldRight(floats, b: Float(1))(f:{$0 * $1})
    }
    
    /// Exercise 3.7 - Shortcut foldRight
    func foldRight<A,B>(lst:List<A>, b:B)(f:(A,B)->(Bool,B))->(Bool,B) {
        let (head,tail) = lst.tuple()
        switch (head,tail) {
        case (nil,nil): return (false,b)
        case (let head,let tail):
            let (err,res) = foldRight(tail!, b: b)(f:f)
            return err ? (err,res) : f(head!, res)
            
        }
    }
    
    func product3(floats:List<Float>) -> Float {
        let (err,result) = foldRight(floats, b: Float(1))(f:{($0 == Float(0), $0 * $1)})
        return err ? Float(0) : result
    }
    
    func length<A>(list:List<A>) -> Int {
        return foldRight(list,b:0)(f:{1+$1})
    }
    
    /// Exercise 3.10 
    /// Fold left Broken implementation??? not tail recursive
    func foldLeft<A,B>(lst:List<A>, b:B, f: (B,A) -> B) -> B {
        let (head,tail) = lst.tuple()
        switch (head,tail) {
        case (nil,nil): return b
        case (let head,let tail): return f(foldLeft(tail!, b:b, f:f),head!)
        }
    }
    
    func foldLeft2<A,B>(lst:List<A>, b:B)(f: (B,A) -> B) -> B {
        let (head,tail) = lst.tuple()
        switch (head,tail) {
        case (nil,nil): return b
        case (let head,let tail): return f(foldLeft2(tail!, b:b)(f:f),head!)
        }
    }
    
    func foldLeftIterative<A,B>(lst:List<A>, b:B, f: (B,A) -> B) -> B {
        var foldedValue = b
        let length = self.length(lst)
        for var i = 0; i < length; i++ {
            println("lst = \(lst) folded value = \(foldedValue)")
            foldedValue = f(foldedValue,lst[i]!)
        }
        return foldedValue
    }
    
    ///Exercise 3.11
    func sumFoldLeft(ints:List<Int>) -> Int {
        return foldLeft2(ints, b: 0)(f:{$0 + $1})
    }
    
    func productFoldLeft(floats:List<Float>) -> Float {
        return foldLeft2(floats, b: Float(1.0))(f:{$0 * $1})
    }
    
    func lengthFoldLeft<A>(list:List<A>) -> Int {
        return foldLeft(list,b:0,f:{b,a in b+1})
    }
    
    ///Exercise 3.12
    func reverse<A>(lst:List<A>) -> List<A> {
        return foldLeftIterative(lst, b:List<A>(), f: {List<A>(head:$1, tail: $0)})
        //return foldLeft(lst, b:List<A>(), f: {List<A>(head:$1, tail: $0)})
    }
    
    func append<A>(lst:List<A>,a:A) -> List<A> {
        //var lst2 = List<A>(head: a, tail:foldLeftIterative(lst, b:List<A>(), f: {List<A>(head:$1, tail: $0)}))
        //return reverse(lst2)
        let result = foldRight(lst, b:List<A>(head:a))(f: {List<A>(head:$0,tail:$1)})
        return result
    }
    
    func flatten<A>(lst:List<List<A>>) -> List<A> {
        return foldLeftIterative(lst, b: List<A>(), f: {
            d, c in
            self.foldRight(d, b:c)(f: {List<A>(head:$0,tail:$1)})
        })
    }
}
//***************************************************************************************