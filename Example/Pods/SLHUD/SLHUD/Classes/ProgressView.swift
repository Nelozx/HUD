//
//  ProgressView.swift
//  SLHUD
//
//  Created by Nelo on 2021/4/15.
//

import UIKit

public class ProgressView: UIView {
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  public convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  lazy var trackLayer: CAShapeLayer = {
    let lay = CAShapeLayer()
    lay.frame = bounds
    lay.fillColor = UIColor.clear.cgColor
    lay.strokeColor = model.colorTrack.cgColor
    lay.lineWidth = model.lineWidth
    lay.lineCap = model.isRoundTrack ? .round : .butt
    return lay
  }()
  
  lazy var progressLayer:CAShapeLayer = {
    let lay = CAShapeLayer()
    lay.frame = bounds
    lay.fillColor = UIColor.clear.cgColor
    lay.strokeColor = model.colorProgress.cgColor
    lay.lineWidth = model.lineWidth
    lay.lineCap = model.isRoundProgress ? .round : .butt
    self.layer.addSublayer(lay)
    return lay
  }()
  lazy var path:UIBezierPath = {
    UIBezierPath()
  }()
  
  lazy var numberLabel:UILabel = {
    UILabel()
  }()
  
  public var model: Style = Style() {
    didSet{
      trackLayer.strokeColor = model.colorTrack.cgColor
      trackLayer.lineWidth = model.lineWidth
      trackLayer.lineCap = model.isRoundTrack ? .round : .butt
      progressLayer.strokeColor = model.colorProgress.cgColor
      progressLayer.lineWidth = model.lineWidth
      progressLayer.lineCap = model.isRoundProgress ? .round : .butt
      numberLabel.textColor = model.colorTitle
      numberLabel.font = model.fontTitle
      self.setNeedsDisplay()
    }
  }
  
  public typealias ProgressViewHandler = (ProgressView?) -> Void
  
  public var handler: ProgressViewHandler? = nil {
    didSet{
      weak var view: ProgressView? = self
      handler?(view)
    }
  }

  
  open var progress: CGFloat = 0 {
    didSet {
      if progress > 100 {
        progress = 100
      }else if progress < 0 {
        progress = 0
      }
      updateProgress(progress, duration: 0.5)
    }
  }
  
  override public func draw(_ rect: CGRect) {
    path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                radius: bounds.size.width/2 - model.lineWidth,
                startAngle: radian(-90), endAngle: radian(270), clockwise: true)
    numberLabel.bounds = CGRect(x: 0, y: 0, width: bounds.size.width - model.lineWidth*2, height: bounds.size.width - model.lineWidth*2)
    numberLabel.center = center
    numberLabel.textAlignment = .center
    numberLabel.text = String(format: "%.1f", progress) + "%"
    trackLayer.path = path.cgPath
    progressLayer.path = path.cgPath
    progressLayer.strokeStart = 0
    progressLayer.strokeEnd = progress/100.0
  }
}
extension ProgressView {
  private func initialize() {
    self.layer.addSublayer(trackLayer)
    self.layer.addSublayer(progressLayer)
    self.addSubview(numberLabel)
  }
  private func radian(_ angle: CGFloat)->CGFloat {
    return angle/180.0 * CGFloat.pi
  }
  private func updateProgress(_ pro: CGFloat, duration: Double) {
    numberLabel.text = String(format: "%.1f", progress) + "%"
    CATransaction.begin()
    CATransaction.setDisableActions(false)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:.easeInEaseOut))
    CATransaction.setAnimationDuration(duration)
    progressLayer.strokeEnd = progress/100.0
    CATransaction.commit()
  }
}

extension ProgressView {
  public struct Style {
    public static var `default` = Style()
    ///进度条宽度
    public var lineWidth: CGFloat = 5
    ///进度槽是否圆角
    public var isRoundTrack:Bool = false
    ///进度条是否圆角
    public var isRoundProgress:Bool = true
    ///进度槽颜色
    public var colorTrack = UIColor.darkGray.withAlphaComponent(0.3)
    ///进度条颜色
    public var colorProgress = UIColor.white
    /// 数值 颜色
    public var colorTitle:UIColor = UIColor.white
    /// 数值 字体
    public var fontTitle:UIFont = UIFont.systemFont(ofSize: 12)
    
    public init() {}
  }
}
