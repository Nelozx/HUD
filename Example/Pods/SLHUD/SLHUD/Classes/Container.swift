//
//  ContentView.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/12.
//

import UIKit

class Container: UIView {
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
  private var `case`: HUD.Case = .loading()
  private var style: HUD.Style = .default
  
  deinit {
    debugPrint("HUD Container deinit")
  }
}

extension Container {
  func show(_ case: HUD.Case, title: String, style: HUD.Style) {
    self.title = title
    self.case  = `case`
    self.style = style
    switch `case` {
    case .toast:
      makeTextContainer()
      makeTextConstraints()
    case .info, .succeed, .warning, .error, .loading, .progress:
      if title.isEmpty {
        makeIconContainer()
        makeIconConstrains()
      } else {
        makeJointContainer()
        makeJointConstraints()
      }
      break
    default:
      break
    }
  }
}

// MARK: Private
extension Container {
  private func makeJointContainer() {
    makeIconContainer()
    makeTextContainer()
  }
  
  private func makeTextContainer() {
    addSubview(textContainer)
    textContainer.show(title: title, style: style)
  }
  
  private func makeIconContainer() {
    addSubview(iconsContainer)
    iconsContainer.show(`case`, style: style)
  }
}
