//
//  HUD+Animation.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/12.
//

import Foundation

extension HUD: CAAnimationDelegate {
  public func animationDidStart(_ anim: CAAnimation) {}
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      destroyFromHUD()
      removeFromSuperview()
    }
  }
}

/// 动画
extension HUD {
  
  func animation(isHidden: Bool = false) {
    fade(isHidden)
  }
  
  private func fade(_ isHidden: Bool) {
    let animote = CABasicAnimation(keyPath: "opacity")
    animote.duration = 0.3
    animote.isRemovedOnCompletion = false
    animote.fillMode = isHidden ? .backwards : .forwards
    animote.fromValue = isHidden ? 1 : 0
    animote.toValue = isHidden ? 0 : 1
    animote.delegate = isHidden ? self : nil
    layer.add(animote, forKey: animote.keyPath)
  }
}

extension IconsContainer {
  func animationCircleStrokeSpin(_ view: UIView) {
    
    view.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })

    let width = view.frame.size.width
    let height = view.frame.size.height

    let beginTime: Double = 0.5
    let durationStart: Double = 1.2
    let durationStop: Double = 0.7

    let animationRotation = CABasicAnimation(keyPath: "transform.rotation")
    animationRotation.byValue = 2 * Float.pi
    animationRotation.timingFunction = CAMediaTimingFunction(name: .linear)

    let animationStart = CABasicAnimation(keyPath: "strokeStart")
    animationStart.duration = durationStart
    animationStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.2, 1)
    animationStart.fromValue = 0
    animationStart.toValue = 1
    animationStart.beginTime = beginTime

    let animationStop = CABasicAnimation(keyPath: "strokeEnd")
    animationStop.duration = durationStop
    animationStop.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.2, 1)
    animationStop.fromValue = 0
    animationStop.toValue = 1

    let animation = CAAnimationGroup()
    animation.animations = [animationRotation, animationStop, animationStart]
    animation.duration = durationStart + beginTime
    animation.repeatCount = .infinity
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards

    let path = UIBezierPath(arcCenter: CGPoint(x: width/2, y: height/2), radius: width/2, startAngle: -0.5 * .pi, endAngle: 1.5 * .pi, clockwise: true)

    let layer = CAShapeLayer()
    layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    layer.path = path.cgPath
    layer.fillColor = nil
    layer.strokeColor = UIColor.white.cgColor
    layer.lineWidth = 3
    layer.add(animation, forKey: "CircleStrokeSpin")
    view.layer.addSublayer(layer)
  }
  
  func animationLineScaling(_ view: UIView) {
    
    view.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })

    let width = view.frame.size.width
    let height = view.frame.size.height

    let lineWidth = width / 9

    let beginTime = CACurrentMediaTime()
    let beginTimes = [0.5, 0.4, 0.3, 0.2, 0.1]
    let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)

    let animation = CAKeyframeAnimation(keyPath: "transform.scale.y")
    animation.keyTimes = [0, 0.5, 1]
    animation.timingFunctions = [timingFunction, timingFunction]
    animation.values = [1, 0.4, 1]
    animation.duration = 1
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false

    let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: lineWidth, height: height), cornerRadius: width/2)

    for i in 0..<5 {
      let layer = CAShapeLayer()
      layer.frame = CGRect(x: lineWidth * 2 * CGFloat(i), y: 0, width: lineWidth, height: height)
      layer.path = path.cgPath
      layer.backgroundColor = nil
      layer.fillColor = UIColor.white.cgColor

      animation.beginTime = beginTime - beginTimes[i]

      layer.add(animation, forKey: "animation")
      view.layer.addSublayer(layer)
    }
  }
}
