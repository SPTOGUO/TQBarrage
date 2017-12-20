//
//  Barrage.swift
//  BarrageDemo
//
//  Created by Guo Zhiqiang on 17/3/16.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import UIKit

enum BarrageType: Int {
    case rightToLeft
    case leftToRight
    case topToBottom
    case bottomToTop
}

class Barrage {
    var type: BarrageType
    var time: Double!
    var duration: Double!
    var remainTime: Double = 0
    
    var text: String!
    var textColor: UIColor!
    var textSize: CGFloat!
    
    var originX: CGFloat!
    var originY: CGFloat!
    var size: CGSize!
    var isMeasured = false
    var isShowing = false
    var label: UILabel?
    weak var retainer: BarrageRetainer!
    
    var isSelfSend = false
    
    init(type: BarrageType) {
        self.type = type
    }
    
    func renderlabel(paintHeight: CGFloat) {
        label!.alpha = 1
        label!.font = UIFont.systemFont(ofSize: textSize)
        label!.text = text
        label!.textColor = textColor
        label!.sizeToFit()
        size = CGSize(width: label!.frame.width, height: paintHeight)
        
    }
    
    func layoutWithScreenWidth(width: CGFloat) {
        //子类实现
    }
    
    func originX(screenWidth: CGFloat, remainTime: Double) -> CGFloat {
        return -self.size.width
    }
    
    func isLate(currentTime: TimeInterval) -> Bool {
        return (currentTime + 1) < self.time
    }
    
    func isDraw(currentTime: TimeInterval) -> Bool {
        return self.time >= currentTime
    }
}
