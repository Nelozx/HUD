//
//  TextContentView.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/12.
//

import UIKit

class TextContainer: UIStackView {
  
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
  lazy var titleLabel: UILabel = {
    let titleLabel =  UILabel()
    titleLabel.textColor = .white
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
    titleLabel.font = .systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
    return titleLabel
  }()
  
  lazy var detailLabel: UILabel = {
    let titleLabel =  UILabel()
    titleLabel.textColor = .white
    return titleLabel
  }()
}

extension TextContainer {
  
  func show(title: String = "", detail: String = "") {
    spacing = 10
    if !title.isEmpty {
      addArrangedSubview(titleLabel)
      titleLabel.text = title
    }
  }
}
