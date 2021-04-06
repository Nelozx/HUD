//
//  HUD.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/6.
//

import UIKit

public enum HUDCase {
  case progress(_progress: CGFloat, interaction: Bool = false)
  case toast(_ title: String, offset: CGPoint = .zero)
  case activity(style: ActivityIndicatorStyle, title: String? = nil, subtitle: String? = nil)
  case succeed(_ desc: String? = nil)
  case failed(_ desc: String? = nil)
  case info(_ desc: String? = nil)
  case custom(_ view: UIView)
}

public enum ActivityIndicatorStyle {
  case `default`
  case systemActivityIndicator
}


public class HUD: UIView {
  
  convenience private init() {
    self.init(frame: UIScreen.main.bounds)
    self.alpha = 0
  }
  required internal init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override private init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  static let shared: HUD = {
    let instance = HUD()
    return instance
  }()

}

// MARK: Public
extension HUD {
  public class func show(_ case: HUDCase) {
    
  }
  
  public class func dismiss() {
    
  }
}

// MARK: Private
extension HUD {
  private func _hide() {
  }
}
