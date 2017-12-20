//
//  WalkTextBarrage.swift
//  BarrageDemo
//
//  Created by Guo Zhiqiang on 17/3/14.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import UIKit

class BarrageRightHorizontal: Barrage {
    override func layoutWithScreenWidth(width: CGFloat) {
        originX = originX(screenWidth: width, remainTime: remainTime)
    }
    
    override func originX(screenWidth: CGFloat, remainTime: Double) -> CGFloat {
        return (screenWidth + size.width) / CGFloat(duration) * CGFloat(remainTime) - size.width
    }
}

class BarrageleftHorizontal: Barrage {
    override func layoutWithScreenWidth(width: CGFloat) {
        originX = originX(screenWidth: width, remainTime: remainTime)
    }
    
    override func originX(screenWidth: CGFloat, remainTime: Double) -> CGFloat {
        return (screenWidth + size.width) / CGFloat(duration) * CGFloat(remainTime) - size.width + screenWidth
    }
}

class BarrageTopVertical: Barrage {
    override func layoutWithScreenWidth(width: CGFloat) {
        originX = (width - size.width) / 2
        var alpha: CGFloat = 0
        if self.remainTime > 0 && self.remainTime < self.duration {
            alpha = 1
        }
        label?.alpha = alpha
    }
}

class BarrageBottomVertical: BarrageTopVertical {
    
}
