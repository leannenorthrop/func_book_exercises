///
///  Chp1.swift
///  Example and exercise code from 'Functional Programming in Scala' in Swift.
///
///  Created by Leanne Northrop on 03/07/2015.
///
///  Thanks to:
/// - http://www.juliusparishy.com/articles/2014/12/14/adopting-map-reduce-in-swift
/// - GroupBy comes from https://www.snip2code.com/Snippet/281367/Swift--Group-array-values-into-a-diction.
/// - Unzip comes from https://gist.github.com/kristopherjohnson/04dbc470e17f67f836a2

import Foundation

/**
    Converts array of pair tuple to a pair tuple of two arrays

    :param: `array` Array of pair tuples

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

    :param: `keyFunc` Mapping function from value to key
    :returns: function taking a list of values and returning a dictionary of key, value pairs
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
///
/// :param: `charges` list of multiple charges to multiple credit cards
/// :returns: list of charges with one charge per unique credit card
func coalesce(charges: [Charge]) -> [Charge] {
    // Group credit card charges to unique cards
    func keyFunc(v:Charge) -> String? { return v.cc.number }
    let grouped = groupBy(keyFunc)(charges)
    
    // Combine charges for each unique card
    let combined : [(String,Charge)] = map(grouped){
        (key, value) in
        (key, value.reduce(Charge(cc:value[0].cc, amount: 0)){
            charge1, charge2 in
            charge1.combine(charge2)
        })
    }
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

        :param: `other` A charge to a credit card
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
    p6 of Chapter 1
*/
struct Cafe {
    /**
        Purchase a single cup of coffee and charge to card.
    
        :param: `cc` credit card to charge
        :returns: purchase tuple of cup of coffee and charge to credit card
    */
    func buyCoffee(cc:CreditCard) -> (Coffee,Charge) {
        let cup = Coffee(price:3.2)
        return (cup, Charge(cc: cc,amount:cup.price))
    }

    /**
        Purchase multiple cups of coffee and charge to card.
    
        :param: `cc` Credit card to make purchases with
        :param: `n` Number of cups of coffee to purchase
        :returns: purchase tuple of cups of coffee and single charge to credit card
    */
    func buyCoffees(cc:CreditCard, n:Int) -> ([Coffee], Charge) {
        // Create list of coffee & charge purchase tuples
        let purchases = Array((0..<n).map({ _ -> (Coffee,Charge) in self.buyCoffee(cc) }))
        
        // Flip coffee & charge tuples to two lists
        let tuple : (coffees:[Coffee], charges:[Charge]) = unzip(purchases)
        
        // Create a single charge as all purchases are to the same card
        // by combining charge amounts
        let charge = tuple.charges.reduce(Charge(cc:cc, amount: 0)){
            charge1, charge2 in
            charge1.combine(charge2)
        }
        
        return (tuple.coffees, charge)
    }
}