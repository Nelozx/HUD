//
//  ActivityContainer.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/13.
//

import UIKit

class IconsContainer: UIStackView {
  lazy var gifView: UIImageView = {
    let gifView = UIImageView()
    gifView.translatesAutoresizingMaskIntoConstraints = false
    return gifView
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
    activityView.color = style.iconColor
    return activityView
  }()
  
  lazy var progressView: ProgressView = {
    let progressView = ProgressView()
    progressView.translatesAutoresizingMaskIntoConstraints = false
    return ProgressView()
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
  
  var style: HUD.Style = .default
}

extension IconsContainer {
  func show(_ case: HUD.Case, style: HUD.Style) {
    spacing = 10
    switch `case` {
    case .loading(let type, _):
      makeActivity(type)
      break
    case .succeed:
      addArrangedSubview(animateView)
      makeAnimatinViewConstraints()
      layoutIfNeeded()
      animatedIconSucceed(animateView)
    case .error:
      addArrangedSubview(animateView)
      makeAnimatinViewConstraints()
      layoutIfNeeded()
      animatedIconFailed(animateView)
    case .progress(let style, _, let handler):
      progressView.model = style
      progressView.handler = handler
      addArrangedSubview(progressView)
      makeProgressViewConstraints()
      
    default:
      break
    }
  }
  
  func makeActivity(_ type: HUD.LoadingType)  {
    switch type {
    case .default:
      addArrangedSubview(activityView)
      makeActivityConstraints()
    case .frames(let images, let duration, let repeatCount):
      addArrangedSubview(gifView)
      if images.count <= 0 { return}
      gifView.image = images.last
      gifView.animationImages = images
      gifView.animationDuration = duration
      gifView.animationRepeatCount = repeatCount
      gifView.startAnimating()
    case .ring, .lineScaling, .singleCirclePulse:
      addArrangedSubview(animateView)
      makeAnimatinViewConstraints()
      layoutIfNeeded()
      animate(with: type, in: animateView)
    }
  }
}
