//
//  GameView.swift
//  2048
//
//  Created by 马演喆 on 2019/2/2.
//  Copyright © 2019年 马演喆. All rights reserved.
//

import UIKit

protocol GameViewDelegate {
    func slideEnded(offset: CGPoint)
}

class GameView: UIView {

    var size = 0
    var delegate: GameViewDelegate? = nil
    
    private var startLocation = CGPoint()
    private var touchingDetectable = true
    private let margin: CGFloat = 5.0
    
    private var drawBound: CGRect {
        var bound = self.bounds
        bound.origin.x += margin; bound.origin.y += margin
        bound.size.width -= margin * 2; bound.size.height -= margin * 2
        return bound
    }
    
    private var boundSize: CGFloat{
        let viewWidth = drawBound.size.width
        return viewWidth / CGFloat(size)
    }
    
    private var cardSize: CGSize{
        return CGSize(width: boundSize - margin * 2, height: boundSize - margin * 2)
    }
    
    private func getRectOf(row: Int, col: Int) -> CGRect{
        var location = CGPoint(x: CGFloat(col) * boundSize, y: CGFloat(row) * boundSize)
        location.x += margin + drawBound.origin.x
        location.y += margin + drawBound.origin.y
        return CGRect(origin: location, size: cardSize)
    }
    
    override func draw(_ rect: CGRect) {
        UIColor(displayP3Red: 0.8, green: 0.75, blue: 0.71, alpha: 1).setFill()
        for row in 0..<size {
            for col in 0..<size{
                let rect = UIBezierPath(
                    roundedRect: getRectOf(row: row, col: col),
                    cornerRadius: 10.0
            )
                rect.fill()
            }
        }
    }
    
    func performActions(_ actions: [Action]) {
        for action in actions {
            switch action {
            case .new(let position, let newValue):
                newCard(at: position, withValue: newValue)
            case .move(let from, let to):
                moveCard(from: from, to: to)
            case .upgrade(let from, let to, let newValue):
                upgrade(from: from, to: to, newValue: newValue)
            default:
                break
            }
        }
    }
    
    private func getCardView(at position: Position) -> CardView? {
        return viewWithTag(tag(at: position)) as? CardView
    }
    
    private func tag(at position: Position) -> Int{
        return (1 + position.row) * 100 + position.col
    }
    
    private func newCard(at position: Position, withValue value: Int){
        if let cardView = getCardView(at: position) {
            cardView.flash(withValue: value)
        }else {
            let newCardView = CardView(
            frame: getRectOf(row: position.row, col: position.col),
            value: value
        )
            newCardView.tag = tag(at: position)
            addSubview(newCardView)
            newCardView.createAnimation()
        }
    }
    
    private func moveCard(from: Position, to: Position, completion: (() -> Void)? = nil){
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.06 * Double(max(abs(from.row - to.row), abs(from.col - to.col))), delay: 0.0,
            options: [],
            animations: {
                if let cardView = self.getCardView(at: from){
                    cardView.frame = self.getRectOf(row: to.row, col: to.col)
                    cardView.tag = self.tag(at: to)
                }
        }) { position in
            completion?()
        }
    }
    
    private func upgrade(from: Position, to: Position, newValue: Int){
        moveCard(from: from, to: to) {
            if let cardView = self.getCardView(at: to){
                cardView.removeFromSuperview()
            }
            self.newCard(at: to, withValue: newValue)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            startLocation = touch.preciseLocation(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touchingDetectable {
            return
        }
        
        if let touch = touches.first{
            let endLocation = touch.preciseLocation(in: self)
            if (distance(between: endLocation, and: startLocation) > 50){
                touchingDetectable = false
                let offset = endLocation - startLocation
                delegate?.slideEnded(offset: offset)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchingDetectable{
            if let touch = touches.first{
                let endLocation = touch.preciseLocation(in: self)
                let offset = endLocation - startLocation
                delegate?.slideEnded(offset: offset)
            }
        }else {
            touchingDetectable = true
        }
    }
    
    
    private func distance(between pointA: CGPoint, and pointB: CGPoint) -> Double {
        return sqrt(Double((pointA.x - pointB.x) * (pointA.x - pointB.x) + (pointA.y - pointB.y) * (pointA.y - pointB.y)))
    }
}


extension CGPoint {
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
