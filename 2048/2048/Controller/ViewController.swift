//
//  ViewController.swift
//  2048
//
//  Created by 马演喆 on 2019/1/31.
//  Copyright © 2019年 马演喆. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let size = 4
    private lazy var game = Game(size: size)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        game.start()
        game.debugPrint()
        game.move(.down)
        game.debugPrint()
        game.move(.up)
        game.debugPrint()
        game.move(.left)
        game.debugPrint()
        game.move(.right)
        game.debugPrint()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

