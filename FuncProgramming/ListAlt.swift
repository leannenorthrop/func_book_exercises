//
//  ListAlt.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 06/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
//

import Foundation

protocol List2 {}

enum Cons<A> : List2 {
    case Empty
    case Node(A,List2)
}