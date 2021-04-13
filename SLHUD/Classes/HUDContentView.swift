//
//  ContentView.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/12.
//

import UIKit

class HUDContentView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  init() {
    super.init(frame: .zero)
    backgroundColor = UIColor(red: 140/225, green: 140/225, blue: 140/225, alpha: 1.0)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  lazy var textContainer: TextContainer = {
    let  textContainer = TextContainer()
    return textContainer
  }()
  
  lazy var iconsContainer: IconsContainer = {
    let ionsContainer = IconsContainer()
    return ionsContainer
  }()
  
  private var title = ""
  private var `case`: HUD.Case = .activity()
}

extension HUDContentView {
  func show(_ case: HUD.Case, title: String) {
    subviews.forEach { $0.removeFromSuperview() }
    self.title = title
    self.case  = `case`
    switch `case` {
    case .toast:
      makeTextContainer()
    case .info, .succeed, .warning, .error, .activity:
      if title.isEmpty {
        makeIconContainer()
      } else {
        makeIconContainer()
        makeTextContainer()
      }
      break
    default:
      break
    }
  }
  
  private func makeTextContainer() {
    addSubview(textContainer)
    textContainer.show(title: title)
    makeTextConstraints()
  }
  
  private func makeIconContainer() {
    addSubview(iconsContainer)
    iconsContainer.show(`case`)
    makeIconConstrains()
  }

}
