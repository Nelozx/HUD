//
//  HUD+Animation.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/12.
//

import Foundation

extension HUD: CAAnimationDelegate {
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      destroyHUD()
    }
  }
}

/// 动画
extension HUD {
  
  func animation(isRemove: Bool = false) {
    fade(isRemove)
  }
  
  private func fade(_ isHidden: Bool) {
    let animote = CABasicAnimation(keyPath: "opacity")
    animote.duration = 0.3
    animote.isRemovedOnCompletion = false
    animote.fillMode = .forwards
    animote.fromValue = isHidden ? 1 : 0
    animote.toValue = isHidden ? 0 : 1
    animote.delegate = isHidden ? self : nil
    layer.add(animote, forKey: animote.keyPath)
  }
}

extension IconsContainer {
  
  func animate(with type: HUD.LoadingType, in view: UIView) {
    switch type {
    case .lineScaling:
      lineScalingAnimation(in: view)
    case .ring:
      ringAnimation(in: view)
    case .singleCirclePulse:
      singleCirclePulseAnimation(in: view)
    default: break
    }
  }
  
  private func ringAnimation(in view: UIView) {
    let width = view.frame.size.width
    let itemWidth = view.frame.size.width * 0.8
    let itemHeight = itemWidth
    let itemX = (width - itemWidth) * 0.5
    let itemY = itemX

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

    let path = UIBezierPath(arcCenter: CGPoint(x: itemWidth/2, y: itemHeight/2), radius: itemWidth/2, startAngle: -0.5 * .pi, endAngle: 1.5 * .pi, clockwise: true)

    let layer = CAShapeLayer()
    layer.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
    layer.path = path.cgPath
    layer.fillColor = nil
    layer.strokeColor = style.iconColor.cgColor
    layer.lineWidth = 3
    layer.add(animation, forKey: "CircleStrokeSpin")
    view.layer.addSublayer(layer)
  }
  
  func lineScalingAnimation(in view: UIView) {

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
      layer.fillColor = style.iconColor.cgColor

      animation.beginTime = beginTime - beginTimes[i]

      layer.add(animation, forKey: "animationLineScaling")
      view.layer.addSublayer(layer)
    }
  }
  
  func animatedIconSucceed(_ view: UIView) {

    let length = view.frame.width
    let delay = (self.alpha == 0) ? 0.25 : 0.0

    let path = UIBezierPath()
    path.move(to: CGPoint(x: length * 0.15, y: length * 0.50))
    path.addLine(to: CGPoint(x: length * 0.5, y: length * 0.80))
    path.addLine(to: CGPoint(x: length * 1.0, y: length * 0.25))

    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.duration = 0.25
    animation.fromValue = 0
    animation.toValue = 1
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    animation.beginTime = CACurrentMediaTime() + delay

    let layer = CAShapeLayer()
    layer.path = path.cgPath
    layer.fillColor = UIColor.clear.cgColor
    layer.strokeColor = style.iconColor.cgColor
    layer.lineWidth = 9
    layer.lineCap = .round
    layer.lineJoin = .round
    layer.strokeEnd = 0

    layer.add(animation, forKey: "animation")
    view.layer.addSublayer(layer)
  }
  
  func animatedIconFailed(_ view: UIView) {
    let length = view.frame.width
    let delay = (self.alpha == 0) ? 0.25 : 0.0

    let path1 = UIBezierPath()
    let path2 = UIBezierPath()

    path1.move(to: CGPoint(x: length * 0.15, y: length * 0.15))
    path2.move(to: CGPoint(x: length * 0.15, y: length * 0.85))

    path1.addLine(to: CGPoint(x: length * 0.85, y: length * 0.85))
    path2.addLine(to: CGPoint(x: length * 0.85, y: length * 0.15))

    let paths = [path1, path2]

    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.duration = 0.15
    animation.fromValue = 0
    animation.toValue = 1
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false

    for i in 0..<2 {
      let layer = CAShapeLayer()
      layer.path = paths[i].cgPath
      layer.fillColor = UIColor.clear.cgColor
      layer.strokeColor = style.iconColor.cgColor
      layer.lineWidth = 9
      layer.lineCap = .round
      layer.lineJoin = .round
      layer.strokeEnd = 0
      animation.beginTime = CACurrentMediaTime() + 0.25 * Double(i) + delay

      layer.add(animation, forKey: "animation")
      view.layer.addSublayer(layer)
    }
  }
  
  private func singleCirclePulseAnimation(in view: UIView) {

    let width = view.frame.size.width
    let height = view.frame.size.height

    let duration: CFTimeInterval = 1.0

    let animationScale = CABasicAnimation(keyPath: "transform.scale")
    animationScale.duration = duration
    animationScale.fromValue = 0
    animationScale.toValue = 1

    let animationOpacity = CABasicAnimation(keyPath: "opacity")
    animationOpacity.duration = duration
    animationOpacity.fromValue = 1
    animationOpacity.toValue = 0

    let animation = CAAnimationGroup()
    animation.animations = [animationScale, animationOpacity]
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = duration
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false

    let path = UIBezierPath(arcCenter: CGPoint(x: width/2, y: height/2), radius: width/2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

    let layer = CAShapeLayer()
    layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    layer.path = path.cgPath
    layer.fillColor = style.iconColor.cgColor

    layer.add(animation, forKey: "animation")
    view.layer.addSublayer(layer)
  }
}
