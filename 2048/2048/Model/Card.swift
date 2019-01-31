//
//  Card.swift
//  2048
//
//  Created by 马演喆 on 2019/1/31.
//  Copyright © 2019年 马演喆. All rights reserved.
//

import Foundation

class Card {

    private var value=0

    init(value: Int = 0) {
        self.value=value
    }
    
    func getValue() -> Int {
        return value
    }
    
    func upgrade() -> Int {
        value *= 2
        return value
    }
}
