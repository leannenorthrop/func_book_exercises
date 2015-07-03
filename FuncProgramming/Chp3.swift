//
//  Chp3.swift
//  FuncProgramming
//
//  Created by Leanne Northrop on 03/07/2015.
//  Copyright (c) 2015 Leanne Northrop. All rights reserved.
//

import Foundation

class List<A> {
    let list:[A]
    var isEmpty : Bool {
        return self.list.isEmpty
    }
    
    init() {
        list = []
    }
    
    init(a:A...){
        list = Array(a)
    }
}