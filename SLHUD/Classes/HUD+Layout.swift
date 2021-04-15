//
//  Layout.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/12.
//

extension HUD {
  
  func makeConstraints() {
    guard let superview = superview,
          let contentView = contentView else {return}
    if style.isInteraction {
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
    }else{
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
    }
    makeCommonConstraints()
  }
  
  func makeCustomViewConstraints(size: CGSize) {
    guard let contentView = contentView else {return}
    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalToConstant: size.width),
      contentView.heightAnchor.constraint(equalToConstant: size.height),
    ])
  }
  
  private func makeCommonConstraints() {
    guard let contentView = contentView else {return}
    switch `case` {
    case .succeed, .info, .loading, .progress, .warning, .error:
      contentView.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    default: break
    }
  }
}

extension Container {
  
  func makeJointConstraints() {

    NSLayoutConstraint.activate([
      iconsContainer.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      iconsContainer.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
      iconsContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
      textContainer.topAnchor.constraint(equalTo: iconsContainer.bottomAnchor, constant: 10),
      textContainer.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
      textContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
      textContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    ])
  }
  
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
  
  func makeProgressViewConstraints() {
    NSLayoutConstraint.activate([
      progressView.heightAnchor.constraint(equalToConstant: 60),
      progressView.widthAnchor.constraint(equalToConstant: 60)
    ])
  }
}
