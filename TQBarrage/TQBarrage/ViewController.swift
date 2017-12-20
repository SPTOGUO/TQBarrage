//
//  ViewController.swift
//  BarrageDemo
//
//  Created by Guo Zhiqiang on 17/3/14.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate var barrageContainer: BarrageContainer!
    fileprivate var startTime = Date()
    fileprivate var timeView: TimeView!
    fileprivate var timer: Timer?
    
    override func loadView() {
        super.loadView()
        
}

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let configuration = BarrageConfiguration(duration: 6.5, height: 20, fontSize: 17, largeFontSize: 19, maxLRShowCount: 30, maxShowCount: 40)
        let rect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        barrageContainer = BarrageContainer(frame: rect, configuration: configuration)
        barrageContainer.dataSource = self
        view.addSubview(barrageContainer)
        
        timeView = TimeView(frame: CGRect(x: 0, y: view.frame.height - 40, width: view.frame.width, height: 40))
        timeView.delegate = self
        view.addSubview(timeView)

        
        var barrageDescriptors = [BarrageDescriptor]()
        for i in 0..<100 {
            let barrageDescriptor = BarrageDescriptor(text: "神器神器神器 biubiubiubiubiu，bgmbgmBMGBMGBMGBMGBMGBGMBGMBGMBGM", type: 0, time: TimeInterval(i), color: UIColor.red)
            let barrageDescriptor2 = BarrageDescriptor(text: "肯德基份肯德基卡上的咖啡没开始", type: 0, time: TimeInterval(i), color: UIColor.yellow)
            let barrageDescriptor5 = BarrageDescriptor(text: "咖喱第三方老师达历山德罗什么 v 什么是 v 貌似 v Ms vs劳动模范莱德斯马发生的美食，弹幕", type: 0, time: TimeInterval(i), color: UIColor.orange)
            let barrageDescriptor3 = BarrageDescriptor(text: "收到了三闾大夫了", type: 2, time: TimeInterval(i), color: UIColor.green)
            let barrageDescriptor8 = BarrageDescriptor(text: "看到什么才是打开 v 梅开三度 v 梅开三度 v 梅开三度开幕", type: 2, time: TimeInterval(i), color: UIColor.green)
            let barrageDescriptor4 = BarrageDescriptor(text: "两队实力发大发上看到茅塞顿开出门", type: 3, time: TimeInterval(i), color: UIColor.black)
            let barrageDescriptor7 = BarrageDescriptor(text: "走起", type: 3, time: TimeInterval(i), color: UIColor.black)
            let barrageDescriptor6 = BarrageDescriptor(text: "三大开发的时刻 v 的时刻 v 尼克斯队 v 你的伤口 v 纳斯达克 v 难受那说明你是否明白你是否能被罚款生不逢时你看不上疯牛病康师傅", type: 0, time: TimeInterval(i), color: UIColor.purple)
            
            barrageDescriptors.append(barrageDescriptor)
            barrageDescriptors.append(barrageDescriptor2)
            barrageDescriptors.append(barrageDescriptor3)
            barrageDescriptors.append(barrageDescriptor4)
            barrageDescriptors.append(barrageDescriptor5)
            barrageDescriptors.append(barrageDescriptor6)
            barrageDescriptors.append(barrageDescriptor7)
            barrageDescriptors.append(barrageDescriptor8)
        }
        
        barrageContainer.prepareBarrage(BarrageDescriptors: barrageDescriptors)
    }
    
    @objc func seconds() {
        timeView.slider.value += 1
        if timeView.slider.value == 100 {
            timeView.slider.value = 0
        }
        timeView.timeLabel.text = String(format: "%.0f", timeView.slider.value)
    }
    
    func sendBarrage() {
        let time = self.getPlayTime() + 1
        let barrageDescriptor = BarrageDescriptor(text: "自己自己自己自己自己", type: 0, time: TimeInterval(time), color: UIColor.red)
        barrageContainer.sendBarrage(des: barrageDescriptor)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}



extension ViewController: BarrageContainerDataSource {
    func getPlayTime() -> TimeInterval {
//        return Date().timeIntervalSince(startTime)
        return TimeInterval(timeView.slider.value)
    }
}

extension ViewController: TimeViewDelegate {
    func buttonClicked(type: ButtonType) {
        switch type {
        case .start:
            guard barrageContainer.isPrepared else { return }
            
            startTime = Date()
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.seconds), userInfo: nil, repeats: true)
            }
            barrageContainer.start()
        case .pause:
            if timer != nil {
                stopTimer()
            }
            barrageContainer.pause()
        case .send:
            sendBarrage()
        }
    }
}

