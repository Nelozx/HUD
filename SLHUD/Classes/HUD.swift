//
//  HUD.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/6.
//

import UIKit


public class HUD: UIView {
  static let shared = HUD()
  var `case`: HUD.Case = .toast("")
  //  var coverView: UIView?
  lazy var contentView = HUDContentView()
  private var desc = ""
  private(set) var isInteraction = false
  private var durations: (min: TimeInterval, max: TimeInterval) = (min: 1.5, max: 10)
  private let keyboardWillShow  = UIResponder.keyboardWillShowNotification
  private let keyboardWillHide  = UIResponder.keyboardWillHideNotification
  private let keyboardDidShow    = UIResponder.keyboardDidShowNotification
  private let keyboardDidHide    = UIResponder.keyboardDidHideNotification
  private let orientationDidChange = UIDevice.orientationDidChangeNotification
  
  convenience private init() {
    self.init(frame: UIScreen.main.bounds)
    alpha = 0
    translatesAutoresizingMaskIntoConstraints = false
  }
  required internal init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override private init(frame: CGRect) {
    super.init(frame: frame)
  }
}



// MARK: Public
extension HUD {
  
  /// 展示的样式
  public enum Case {
    case toast(_ desc: String)
    case activity(_ type: IndicatorType = .default, desc: String = "")
    case progress(_ progress: CGFloat)
    case custom(_ view: UIView)
    case succeed(_ desc: String = "")
    case error(_ desc: String = "")
    case warning(_ desc: String = "")
    case info(_ desc: String = "")
  
  }
  
  /// 活动指示器的类型
  public enum IndicatorType {
    case `default`
    case ring
    case lineScaling
    case frames(_ images: [UIImage], _ duration: TimeInterval, _ repeatCount: Int)
  }
  
  /// 展示
  /// - Parameter case: Toast & loading & progress & custom
  public class func show(_ case: Case,
                         for superView: UIView = UIWindow.key,
                         isInteraction: Bool = false,
                         duration: TimeInterval = TimeInterval.auto) {
    shared.case = `case`
    shared.isInteraction = isInteraction
    shared.show(for: superView)

    switch `case` {
    case .toast, .info, .succeed, .warning, .error:
      shared.dismiss(with: duration)
      break
    default:
      break
    }
  }
  
  
  /// 移除
  public class func dismiss(with duration: TimeInterval = 0) {
    shared.dismiss(with: duration)
  }
}

// MARK: Private
extension HUD {
  
  private func dismiss(with duration: TimeInterval) {
    if duration == 0 {
      animation(isHidden: true)
      return
    }
    var delay = duration
    if delay == TimeInterval.auto {
      let count: TimeInterval = Double(desc.count) * 0.03 + 1.25
      delay = count < durations.min ? durations.min
        : (count > durations.max ? durations.max : count)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      self.animation(isHidden: true)
    }
  }
  
  private func show(for superView: UIView) {
    superView.addSubview(self)
    buildViews()
  }
  
  
  private func buildViews() {
    //    backgroundColor = UIColor.green
    switch `case` {
    case .toast(let desc), .activity(_ ,let desc),
         .info(let desc), .error(let desc),
         .succeed(let desc), .warning(let desc):
      self.desc = desc
      makeContentView()
    default:
      break
    }
    animation()
  }
  
  private func makeContentView() {
    addSubview(contentView)
    contentView.show(`case`, title: desc)
    makeConstraints()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    switch `case` {
    case .toast:
      contentView.layer.cornerRadius = (contentView.bounds.size.height * 0.5)
    default:
      contentView.layer.cornerRadius = 5
    }
  }
  
  func destroyFromHUD() {
    NotificationCenter.default.removeObserver(self)
    contentView.removeFromSuperview()
  }
  
  //  private func setupCoverView(_ interaction: Bool) {
  //
  //    if (coverView == nil) {
  //      coverView = UIView(frame: self.bounds)
  ////      Self.key.addSubview(coverView!)
  //    }
  //
  //    coverView?.backgroundColor = interaction ? .clear : UIColor(white: 0, alpha: 0.2)
  //    coverView?.isUserInteractionEnabled = (interaction == false)
  //  }
  
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
extension HUD {
  // TODO: Custom Style
  struct Style {}
}

extension UIWindow {
  public class var key: UIWindow {
    UIApplication.shared.windows.first ?? UIWindow()
  }
}

extension TimeInterval {
  public static let auto: TimeInterval = -1
}

