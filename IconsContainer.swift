//
//  ActivityContainer.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/13.
//

import UIKit

class IconsContainer: UIStackView {
  lazy var gifView: UIImageView = {
    UIImageView()
  }()
  
  lazy var label: UILabel = {
    return UILabel()
  }()
  
  lazy var animateView: UIView = {
    let animateView = UIView()
    animateView.translatesAutoresizingMaskIntoConstraints = false
    return animateView
  }()
  
  lazy var activityView: UIActivityIndicatorView  = {
    let activityView = UIActivityIndicatorView()
    activityView.translatesAutoresizingMaskIntoConstraints = false
    activityView.style = .whiteLarge
    activityView.startAnimating()
    return activityView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
  convenience init() {
    self.init(frame: CGRect.zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
}

extension IconsContainer {
  func show(_ case: HUD.Case) {
    subviews.forEach { $0.removeFromSuperview() }
    spacing = 10
    switch `case` {
    case .activity(let type, _):
      makeActivity(type)
      break
    default:
      break
    }
  }
  
  func makeActivity(_ type: HUD.IndicatorType)  {
    switch type {
    case .default:
      addArrangedSubview(activityView)
      makeActivityConstraints()
    case .ring:
      addArrangedSubview(animateView)
      makeAnimatinViewConstraints()
      layoutIfNeeded()
      animationCircleStrokeSpin(animateView)
    case .frames(let images, let duration, let repeatCount):
      addArrangedSubview(gifView)
      if images.count <= 0 { return}
      gifView.image = images.last
      gifView.animationImages = images
      gifView.animationDuration = duration
      gifView.animationRepeatCount = repeatCount
      gifView.startAnimating()
    case .lineScaling:
      addArrangedSubview(animateView)
      makeAnimatinViewConstraints()
      layoutIfNeeded()
      animationLineScaling(animateView)
    }
  }
}
