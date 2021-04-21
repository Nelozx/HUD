//
//  ViewController.swift
//  SLHUD
//
//  Created by nelozx@163.com on 04/06/2021.
//  Copyright (c) 2021 nelozx@163.com. All rights reserved.
//

import UIKit
import SLHUD
import Lottie


class ViewController: UIViewController {
  
  struct Model {
    var desc = ""
  }
  
  var tf: UITextField = UITextField()
  var isSelected: Bool = false
  
  private var models: [Model] = [
    Model(desc: "⏏️: 隐藏/显示键盘"),
    Model(desc: "⏏️: 自定义样式的消息弹窗"),
    Model(desc: "⏏️: 消息弹窗添加在当前视图上"),
    Model(desc: "⏏️: 自定义视图"),
    Model(desc: "⏏️: 系统样式的活动指示器"),
    Model(desc: "⏏️: 转圈活动指示器"),
    Model(desc: "⏏️: 自定义活动指示器"),
    Model(desc: "⏏️: 成功状态"),
    Model(desc: "⏏️: 活动指示器 + 失败状态"),
    Model(desc: "⏏️: 进度"),
    Model(desc: "⏏️: Lottie动画"),
    Model(desc: "⏏️: 带title的Lottie动画")
  ]

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    self.view.addSubview(tf)
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell_table")  else {
      return UITableViewCell()
    }
    cell.textLabel?.text = models[indexPath.row].desc
    cell.textLabel?.textColor = .systemPink
    cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
    cell.accessoryType = .none
    if indexPath.row % 2 == 0 {
      cell.contentView.backgroundColor = .groupTableViewBackground
    } else {
      cell.contentView.backgroundColor = .white
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    defer {
      switch indexPath.row {
      case 3, 4, 5, 6:
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
          HUD.dismiss()
        }
      default: break
      }
    }
    switch indexPath.row {
    case 0:
      isSelected = !isSelected
      if isSelected {
        tf.becomeFirstResponder()
      } else {
        tf.resignFirstResponder()
      }
    case 1:
      var style = HUD.Style()
      style.maskColor = UIColor.gray.withAlphaComponent(0.5)
      style.contentColor = UIColor.red.withAlphaComponent(0.5)
      style.titleColor = .green
      style.isTapContentDismiss = true
      style.isTapMaskDismiss = true
      HUD.show(.toast("验证码复制失败"), style: style)
      break
    case 2:
      HUD.show(.toast("当几个粒子在彼此相互作用后，由于各个粒子所拥有的特性已综合成为整体性质，无法单独描述各个粒子的性质，只能描述整体系统的性质，则称这现象为量子缠结或量子纠缠（quantum entanglement）。量子纠缠是一种纯粹发生于量子系统的现象；在经典力学里，找不到类似的现象 当几个粒子在彼此相互作用后，由于各个粒子所拥有的特性已综合成为整体性质，无法单独描述各个粒子的性质，只能描述整体系统的性质，则称这现象为量子缠结或量子纠缠（quantum entanglement）。量子纠缠是一种纯粹发生于量子系统的现象；在经典力学里，找不到类似的现象"), for: self.view)
    case 3:
      var style = HUD.Style()
      style.isInteraction = false
      style.maskColor = .red
      let view = UIView()
      view.backgroundColor = .cyan
      view.layer.cornerRadius = 10
      HUD.show(.custom(view, size: CGSize(width: 100, height: 400)), style: style)
    case 4:
      var style = HUD.Style()
      style.isInteraction = false
      style.maskColor = UIColor.red
      style.isTapContentDismiss = true
      HUD.show(.loading(desc: "加载中..........................加载中........................加载中........................End") ,style: style)
    case 5:
      var style = HUD.Style()
      style.maskColor = UIColor.gray.withAlphaComponent(0.5)
      style.contentColor = UIColor.clear
      style.titleColor = .systemGreen
      HUD.show(.loading(.ring), style: style)
    case 6:
      HUD.show(.loading(.singleCirclePulse))
      self.navigationController?.pushViewController(NextViewViewController(), animated: true)
    case 7:
      HUD.show(.succeed())
    case 8:
      HUD.show(.loading())
      DispatchQueue.main.asyncAfter(deadline: .now()+5) {
        HUD.show(.error())
      }
    case 9:
      HUD.show(.progress(handler: {[weak self] (progressView) in
        guard let self = self else {
          return
        }
        self.run(with: progressView)
      }))
      
    case 10:
      var style = HUD.Style()
      style.isTapContentDismiss = true
      let animtionView = AnimationView(name: "123")
      animtionView.animationSpeed = 1
      animtionView.loopMode = .loop
      animtionView.play()
      animtionView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
      HUD.show(.custom(animtionView, size: CGSize(width: 60, height: 60)), style: style)
    case 11:
      var style = HUD.Style()
      style.isTapContentDismiss = true
      let animtionView = AnimationView(name: "123")
      animtionView.animationSpeed = 1
      animtionView.loopMode = .loop
      animtionView.play()
      HUD.show(.loading(.custom(animtionView), desc: "这里是描述"), style: style)
    default:
      break
    }
  }
  
  private func run(with progressView: ProgressView?) {
    guard let progressView = progressView  else {
      return
    }
    
    if progressView.progress >= 100 {
      HUD.dismiss(with: 0.25)
      HUD.show(.succeed())
      return
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      progressView.progress += 10
      self.run(with: progressView)
    }
  }
}


struct SomeStruct {
  public var iconColor: UIColor = .white
  public var contentColor = UIColor(red: 140/225, green: 140/225, blue: 140/225, alpha: 1.0)
  public var maskColor: UIColor = .clear
  public var isInteraction: Bool = false
  public var duration: TimeInterval = .auto
  public var cornerRadius: CGFloat = 5
  public var titleColor: UIColor = .white
  public var detailColor: UIColor = .white
}
