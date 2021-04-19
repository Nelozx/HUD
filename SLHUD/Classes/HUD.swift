//
//  HUD.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/6.
//

import UIKit

// MARK: Public
extension HUD {
  
  /// 展示
  /// - Parameters:
  ///   - case: .toast & .custom & .progerss & .loading & status
  ///   - superView: 父层， 默认在window上
  ///   - style: 配置风格、包含字体颜色、交互影响、遮罩颜色
  public class func show(_ case: Case, for superView: UIView = UIWindow.key,
                         style: Style = .default) {
    shared.show(`case`, for: superView, style: style)
  }
  
  /// 消失
  /// - Parameter duration: 时长
  public class func dismiss(with duration: TimeInterval = 0) {
    shared.dismiss(with: duration)
  }
  
  /// 展示的情况
  public enum Case {
    /// 消息弹窗(Toast)
    case toast(_ desc: String)
    /// 活动指示器
    case loading(_ type: LoadingType = .default, desc: String = "")
    /// 进度条 在handler中去更新progress
    case progress(_ style: ProgressView.Style = .default, desc: String = "", handler: ProgressView.ProgressViewHandler)
    /// 自定义 在size确定大小, UIImageView & UILabel ... 默认为内容的大小
    case custom(_ view: UIView, size: CGSize = .zero)
    /// 成功状态
    case succeed(_ desc: String = "")
    /// 失败状态
    case error(_ desc: String = "")
    /// 警示状态
    case warning(_ desc: String = "")
    /// 情报状态
    case info(_ desc: String = "")
  }
  
  /// 活动指示器的类型
  public enum LoadingType {
    case `default`
    case ring
    case lineScaling
    case singleCirclePulse
    case frames(_ images: [UIImage], _ duration: TimeInterval, _ repeatCount: Int)
  }
}

public class HUD: UIView {
  static let shared = HUD()
  private(set) var `case`: Case = .loading()
  private(set) var style: Style = .default
  
  weak var contentView: UIView?
  private weak var timer: Timer?
  
  private var desc = ""
  private var heightKeyboard = ""
  
  private var durations: (min: TimeInterval, max: TimeInterval) = (min: 1.5, max: 10)
  private let keyboardWillShow  = UIResponder.keyboardWillShowNotification
  private let keyboardWillHide  = UIResponder.keyboardWillHideNotification
  
  convenience private init() {
    self.init(frame: UIScreen.main.bounds)
    translatesAutoresizingMaskIntoConstraints = false
  }
  required internal init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override private init(frame: CGRect) {
    super.init(frame: frame)
  }
}

// MARK: Private
extension HUD {
  
  private func dismiss(with duration: TimeInterval) {
    if duration == 0 {
      animation(isRemove: true)
      return
    }
    var delay = duration
    if delay == TimeInterval.auto {
      let count: TimeInterval = Double(desc.count) * 0.03 + 1.25
      delay = count < durations.min ? durations.min
        : (count > durations.max ? durations.max : count)
    }
    timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
      self?.animation(isRemove: true)
    }
  }
  
  private func show(_ case: Case, for superView: UIView, style: Style) {
    if contentView != nil { destroyHUD()}
    self.case = `case`
    self.style = style
    superView.addSubview(self)
    interactionCase()
    setupUI()
    autoDisssCase()
    setupNotifications()
  }
  
  private func autoDisssCase() {
    switch `case` {
    case .toast, .succeed, .info, .warning, .error:
      dismiss(with: style.duration)
    default: break
    }
  }
  private func interactionCase() {
    switch `case` {
    case .toast: style.isInteraction = false
    default: break
    }
    backgroundColor = style.isInteraction ? style.maskColor : .clear
  }
  private func setupUI() {
    self.desc = ""
    switch `case` {
    case .toast(let desc), .loading(_ ,let desc),
         .info(let desc), .error(let desc),
         .succeed(let desc), .warning(let desc),
         .progress(_, let desc, _):
      self.desc = desc
      makeContentView()
    case .custom(let contentView, let size):
      contentView.translatesAutoresizingMaskIntoConstraints = false
      self.contentView = contentView
      addSubview(contentView)
      makeCustomViewConstraints(size: size)
    }
    addGestureRecognizer()
    animation()
  }
  
  
  private func addGestureRecognizer() {
    if style.isTapMaskDismiss && style.isInteraction {
      addGestureRecognizer(
        UITapGestureRecognizer(target: self, action: #selector(tapToDissmiss))
      )
    }
    if style.isTapContentDismiss {
      contentView?.addGestureRecognizer(
        UITapGestureRecognizer(target: self, action: #selector(tapToDissmiss))
      )
    }
  }
  
  @objc private func tapToDissmiss() {
    HUD.dismiss()
  }
  
  private func makeContentView() {
    let contentView = Container()
    addSubview(contentView)
    contentView.backgroundColor = style.contentColor
    self.contentView = contentView
    makeConstraints()
    contentView.show(`case`, title: desc, style: style)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    guard let contentView = contentView else {return}
    switch `case` {
    case .toast:
      let contentH = contentView.bounds.size.height
      if contentH > 100 {
        contentView.layer.cornerRadius = style.cornerRadius ?? 5
      } else {
        contentView.layer.cornerRadius = style.cornerRadius ??
          (contentH * 0.5)
      }
    case .custom: break
    default:
      contentView.layer.cornerRadius = style.cornerRadius ?? 5
    }
  }
  
  func destroyHUD() {
    NotificationCenter.default.removeObserver(self)
    contentView?.removeFromSuperview()
    removeFromSuperview()
    timer?.invalidate()
  }
  
  private func setupNotifications() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: keyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: keyboardWillHide, object: nil)
    
  }
  
  @objc func keyboardWillShowNotification(_ note: Notification) {
    
    guard let userInfo = note.userInfo,
          let keyboradRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
          let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
          let contentView = contentView else {
      return
    }
  
   

    print(keyboradRect.minY)
    print(contentView.bounds.height)
//    let offsetY = keyboradRect.minY - self.frame.height
//
//    UIView.animate(withDuration: duration) {
//      self.transform = CGAffineTransform(translationX: 0, y: offsetY)
//    }
  }
}

func keyboardWillHideNotification(_ note: Notification) {
  
}



// MARK: Style
extension HUD {
  public struct Style {
    public init() {}
    public static var `default` = Style()
    /// 图标颜色
    public var iconColor: UIColor = .white
    /// HUD背景色
    public var contentColor = UIColor(red: 140/225, green: 140/225, blue: 140/225, alpha: 1.0)
    /// 遮罩的颜色
    public var maskColor: UIColor = .clear
    /// 是否影响交互
    public var isInteraction: Bool = true
    /// 展示的时长
    public var duration: TimeInterval = .auto
    /// HUD的圆角半径
    public var cornerRadius: CGFloat?
    public var titleColor: UIColor = .white
    public var detailColor: UIColor = .white
    
    /// 点击遮罩消失
    public var isTapMaskDismiss: Bool = false
    /// 点击内容消失
    public var isTapContentDismiss: Bool = false
  }
}

extension UIWindow {
  public class var key: UIWindow {
    UIApplication.shared.windows.first ?? UIWindow()
  }
}

extension TimeInterval {
  public static let auto: TimeInterval = -1
}

