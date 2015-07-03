//
//  Chp1.swift
//  Example code from 'Functional Programming in Scala' in Swift
//
//  Created by Leanne Northrop on 03/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
//

import Foundation

/**
    Converts array of pair tuple to a pair tuple of two arrays

    :param: Array of pair tuples

    :returns: Single pair tuples containing arrays of elements
*/
func unzip<T, U>(array: [(T, U)]) -> ([T], [U]) {
    var t = Array<T>()
    var u = Array<U>()
    for (a, b) in array {
        t.append(a)
        u.append(b)
    }
    return (t, u)
}

/** Given an array collection 
    and a function that optionally maps each element to its corresponding group,
    return a Swift Dictionary of the mapped elements in their groups.
*/
func groupBy<K,V>(keyFunc: V -> K?) -> ([V]) -> [K: [V]] {
    var grouped = [K: [V]]()
    func group(collection: [V]) -> [K: [V]] {
        for c in collection {
            if let o = c as? V {
                if let k = keyFunc(o) {
                    if var group = grouped[k] {
                        group.append(o)
                        grouped[k] = group
                    }
                    else {
                        grouped[k] = [o]
                    }
                }
            }
        }
        return grouped
    }
    return group
}

/// Helper function to combine multiple charges to various cards into
/// single charge per card
func coalesce(charges: [Charge]) -> [Charge] {
    func keyFunc(v:Charge) -> String? { return v.cc.number }
    let grouped = groupBy(keyFunc)(charges)
    let combined : [(String,Charge)] = map(grouped, { (key, value) in (key, value.reduce(Charge(cc:value[0].cc, amount: 0), combine: {$0.combine($1)})) })
    let creditCardCharges : (cc:[String],charges:[Charge]) = unzip(combined)
    return creditCardCharges.charges
}

/**
    Cup of coffee and it's price
*/
struct Coffee : Printable {
    let price:Double
    var description : String { return self.price.description }
    init(price:Double) {
        self.price = price
    }
    
}

/**
    Unique credit card
*/
struct CreditCard : Printable {
    let number: String
    init(number:String) {
        self.number = number
    }
    var description : String { return "CreditCard '\(self.number)':" }
}

/**
    A single charge to a credit card.
*/
struct Charge : Printable {
    let cc:CreditCard
    let amount:Double
    var description : String { return "CreditCard charge: \(amount)" }
    
    init(cc:CreditCard, amount:Double){
        self.cc = cc
        self.amount = amount
    }

    /**
        Helper function to sum charges if the same credit card.

        :param: A charge to a credit card
        :returns: New charge which is sum of charge to this card and 'other' carge if the same card.
    */
    func combine(other: Charge) -> Charge {
        if self.cc.number == other.cc.number {
            return Charge(cc: self.cc, amount: self.amount + other.amount)
        } else {
            return Charge(cc: self.cc, amount: 0)
        }
    }
}

/**
    Coffee cafe allows single or multiple cups of coffee to be purchased.
*/
struct Cafe {
    /**
        Purchase a single cup of coffee and charge to card.
    */
    func buyCoffee(cc:CreditCard) -> (Coffee,Charge) {
        let cup = Coffee(price:3.2)
        return (cup, Charge(cc: cc,amount:cup.price))
    }

    /**
        Purchase multiple cups of coffee and charge to card.
    */
    func buyCoffees(cc:CreditCard, n:Int) -> ([Coffee], Charge) {
        let purchases = Array(lazy(0..<n).map({ _ -> (Coffee,Charge) in self.buyCoffee(cc) }))
        let tuple : (coffees:[Coffee], charges:[Charge]) = unzip(purchases)
        let charges = tuple.charges.reduce(Charge(cc:cc, amount: 0), combine: {$0.combine($1)})
        return (tuple.coffees, charges)
    }
}