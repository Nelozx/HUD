//
//  Layout.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/12.
//

extension HUD {
  
  func makeConstraints() {
    guard let superview = superview else {return}
    if isInteraction {
      NSLayoutConstraint.activate([
        centerXAnchor.constraint(equalTo: superview.centerXAnchor),
        centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 40),
        topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: 40),
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
        contentView.topAnchor.constraint(equalTo: topAnchor),
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
      ])
      
    }else{
      NSLayoutConstraint.activate([
        topAnchor.constraint(equalTo: superview.topAnchor),
        bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        leadingAnchor.constraint(equalTo: superview.leadingAnchor),
        trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
        contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
        contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 40),
        contentView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 40)
      ])
    }
    makeCommonConstraints()
  }
  
  private func makeCommonConstraints() {
    switch `case` {
    case .activity, .info, .succeed, .warning, .error, .progress:
      contentView.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    case .toast:
      debugPrint(contentView.constraints)
      break
    default:
      break
    }
  }
  
}

extension HUDContentView {
  
  func makeTextConstraints() {
    NSLayoutConstraint.activate([
      textContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      textContainer.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      textContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
      textContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
  
  func makeIconConstrains() {
    NSLayoutConstraint.activate([
      iconsContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      iconsContainer.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      iconsContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
      iconsContainer.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  
}

extension IconsContainer {
  
  func makeActivityConstraints() {
    NSLayoutConstraint.activate([
      activityView.heightAnchor.constraint(equalToConstant: 60),
      activityView.widthAnchor.constraint(equalToConstant: 60)
    ])
  }
  
  func makeAnimatinViewConstraints() {
    NSLayoutConstraint.activate([
      animateView.heightAnchor.constraint(equalToConstant: 60),
      animateView.widthAnchor.constraint(equalToConstant: 60)
    ])
  }
}
