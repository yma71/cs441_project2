//
//  Action.swift
//  2048
//
//  Created by 马演喆 on 2019/1/31.
//  Copyright © 2019年 马演喆. All rights reserved.
//

import Foundation

enum  Action {
    case move(from: Position, to: Position)
    case upgrade(from: Position, to: Position, value: Int)
    case new(at: Position, value: Int)
    case success
    case failure
}
