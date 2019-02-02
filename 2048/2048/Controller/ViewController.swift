//
//  ViewController.swift
//  2048
//
//  Created by 马演喆 on 2019/1/31.
//  Copyright © 2019年 马演喆. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameViewDelegate {
    
    private let size = 4
    private lazy var game = Game(size: size)
    
    @IBOutlet weak var gmaView: GameView! {
        didSet {
            gmaView.size = size
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        gmaView.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){
            self.startGame()
        }
    }
    
    private func startGame(){
        self.game.start{ (startCards) in
            self.gmaView.performActions(startCards)
            
        }
    }
    
    func slideEnded(offset: CGPoint) {
        let direction: Direction
        if offset.y > offset.x{
            if offset.y > -offset.x{
                direction = .down
            } else {
              direction = .left
            }
        } else {
            if offset.y > -offset.x{
                direction = .right
            } else {
                direction = .up
            }
        }
        
        game.move(direction){ (actions) in
            gmaView.performActions(actions)
        }
    }

}

