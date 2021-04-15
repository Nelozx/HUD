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
  /// - Parameter case: Toast & loading & progress & custom
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
    /// 消息弹窗(Toast) 必穿文字
    case toast(_ desc: String)
    case loading(_ type: LoadingType = .default, desc: String = "")
    case progress(_ style: ProgressView.Style = .default, handler: ProgressView.ProgressViewHandler)
    case custom(_ view: UIView)
    case succeed(_ desc: String = "")
    case error(_ desc: String = "")
    case warning(_ desc: String = "")
    case info(_ desc: String = "")
  }
  
  /// 活动指示器的类型
  public enum LoadingType {
    case `default`
    case ring
    case lineScaling
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
  private let keyboardDidShow    = UIResponder.keyboardDidShowNotification
  private let keyboardDidHide    = UIResponder.keyboardDidHideNotification
  private let orientationDidChange = UIDevice.orientationDidChangeNotification
  
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
    if contentView != nil {
      contentView?.removeFromSuperview()
      timer?.invalidate()
    }
    self.case = `case`
    self.style = style
    superView.addSubview(self)
    interactionCase()
    setupUI()
    autoDisssCase()
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
    backgroundColor = style.isInteraction ? style.maskColor : .white
  }
  private func setupUI() {
    switch `case` {
    case .toast(let desc), .loading(_ ,let desc),
         .info(let desc), .error(let desc),
         .succeed(let desc), .warning(let desc):
      self.desc = desc
      makeContentView()
    case .progress:
      makeContentView()
    case .custom(let contentView):
      self.contentView = contentView
      addSubview(contentView)
      makeConstraints()
    }
    animation()
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
      contentView.layer.cornerRadius = style.cornerRadius ??
        (contentView.bounds.size.height * 0.5)
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
    
    //    if (coverView == nil) {
    NotificationCenter.default.addObserver(self, selector: #selector(handlerPosition(_:)), name: keyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handlerPosition(_:)), name: keyboardWillHide, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handlerPosition(_:)), name: keyboardDidShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handlerPosition(_:)), name: keyboardDidHide, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handlerPosition(_:)), name: orientationDidChange, object: nil)
    //    }
  }
  
  @objc private func handlerPosition(_ notification: Notification? = nil) {
    
    var heightKeyboard: CGFloat = 0
    var animationDuration: TimeInterval = 0
    
    if let notification = notification {
      let frameKeyboard = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? CGRect.zero
      animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
      
      if (notification.name == keyboardWillShow) || (notification.name == keyboardDidShow) {
        heightKeyboard = frameKeyboard.size.height
      } else if (notification.name == keyboardWillHide) || (notification.name == keyboardDidHide) {
        heightKeyboard = 0
      } else {
//        heightKeyboard = keyboardHeight()
      }
    } else {
//      heightKeyboard = keyboardHeight()
    }
    
    let screen = UIScreen.main.bounds
    let center = CGPoint(x: screen.size.width/2, y: (screen.size.height-heightKeyboard)/2)
    
    UIView.animate(withDuration: animationDuration, delay: 0, options: .allowUserInteraction, animations: {
      //      self.toolbarHUD?.center = center
      //      self.viewBackground?.frame = screen
    }, completion: nil)
  }
  
}

// MARK: Style
extension HUD {
  public struct Style {
    public static var `default` = Style()
    public init() {}
    public var iconColor: UIColor = .white
    public var contentColor = UIColor(red: 140/225, green: 140/225, blue: 140/225, alpha: 1.0)
    public var maskColor: UIColor = .clear
    public var isInteraction: Bool = true
    public var duration: TimeInterval = .auto
    public var cornerRadius: CGFloat?
    public var titleColor: UIColor = .white
    public var detailColor: UIColor = .white
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

