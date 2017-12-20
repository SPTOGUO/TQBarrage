//
//  TimeView.swift
//  BarrageDemo
//
//  Created by Guo Zhiqiang on 17/3/23.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import UIKit

enum ButtonType: Int {
    case start
    case pause
    case send
}

protocol TimeViewDelegate: class {
    func buttonClicked(type: ButtonType)
}

class TimeView: UIView {
    var slider: UISlider!
    var startButton: UIButton!
    var pauseButton: UIButton!
    var sendButton: UIButton!
    var timeLabel: UILabel!
    
    let buttonTag = 666
    
    weak var delegate: TimeViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        steupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func steupViews() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        startButton = UIButton(type: .custom)
        startButton.frame = CGRect(x: 5, y: 10, width: 50, height: 20)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        startButton.setTitle("Start", for: .normal)
        startButton.tag = buttonTag
        startButton.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        addSubview(startButton)
        
        pauseButton = UIButton(type: .custom)
        pauseButton.frame = CGRect(x: startButton.frame.maxX + 5, y: 10, width: 50, height: 20)
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.tag = buttonTag + 1
        pauseButton.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        addSubview(pauseButton)
        
        timeLabel = UILabel()
        timeLabel.frame = CGRect(x: pauseButton.frame.maxX + 5, y: 10, width: 40, height: 20)
        timeLabel.font = UIFont.systemFont(ofSize: 20)
        timeLabel.textAlignment = .center
        addSubview(timeLabel)
        
        slider = UISlider(frame: CGRect(x: timeLabel.frame.maxX + 5, y: 10, width: self.frame.width - timeLabel.frame.maxX + 5 - 65, height: self.frame.height - 20))
        slider.center = CGPoint(x: slider.center.x, y: self.frame.height / 2)
        slider.minimumValue = 0
        slider.maximumValue = 100
        addSubview(slider)
        
        sendButton = UIButton(type: .custom)
        sendButton.frame = CGRect(x: slider.frame.maxX + 5, y: 10, width: 50, height: 20)
        sendButton.setTitle("Send", for: .normal)
        sendButton.tag = buttonTag + 2
        sendButton.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        addSubview(sendButton)
        
    }
    
    @objc func buttonClicked(sender: UIButton) {
        delegate?.buttonClicked(type: ButtonType(rawValue: sender.tag - buttonTag)!)
    }

}
