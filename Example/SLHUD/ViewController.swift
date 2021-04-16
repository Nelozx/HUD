//
//  ViewController.swift
//  SLHUD
//
//  Created by nelozx@163.com on 04/06/2021.
//  Copyright (c) 2021 nelozx@163.com. All rights reserved.
//

import UIKit
import SLHUD


class ViewController: UIViewController, UITextFieldDelegate {
  
  struct Model {
    var desc = ""
  }
  
  private var models: [Model] = [
    Model(desc: "⏏️: 自定义样式的消息弹窗"),
    Model(desc: "⏏️: 基础消息弹窗添加在当前view"),
    Model(desc: "⏏️: 自定义视图"),
    Model(desc: "⏏️: 系统样式的活动指示器"),
    Model(desc: "⏏️: 转圈活动指示器"),
    Model(desc: "⏏️: 自定义活动指示器"),
    Model(desc: "⏏️: 成功"),
    Model(desc: "⏏️: 进度 + 失败"),
    Model(desc: "⏏️: 进度"),
    Model(desc: "⏏️: 键盘遮挡处理"),
  ]

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()

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
    if indexPath.row % 2 == 0 {
      cell.contentView.backgroundColor = .groupTableViewBackground
    } else {
      cell.contentView.backgroundColor = .white
    }
    
    if indexPath.row == 9 {
      let tf = UITextField(frame: cell.bounds)
      tf.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
      tf.borderStyle = .line
      tf.delegate = self
      cell.addSubview(tf)
    }
  
    return cell
  }
  
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    HUD.show(.toast("当几个粒子在彼此相互作用后，由于各个粒子所拥有的特性已综合成为整体性质，无法单独描述各个粒子的性质，只能描述整体系统的性质，则称这现象为量子缠结或量子纠缠（quantum entanglement），当几个粒子在彼此相互作用后，由于各个粒子所拥有的特性已综合成为整体性质，无法单独描述各个粒子的性质，只能描述整体系统的性质，则称这现象为量子缠结或量子纠缠（quantum entanglement）"))
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    view.endEditing(true)
    defer {
      switch indexPath.row {
      case 2, 3, 4, 5:
        DispatchQueue.main.asyncAfter(deadline: .now()+3.5) {
          HUD.dismiss()
        }
      default: break
      }
    }
    switch indexPath.row {
    case 0:
      var style = HUD.Style()
      style.maskColor = UIColor.gray.withAlphaComponent(0.5)
      style.contentColor = UIColor.red.withAlphaComponent(0.5)
      style.titleColor = .green
      style.isTapContentDismiss = true
      style.isTapMaskDismiss = true
      HUD.show(.toast("验证码复制失败-验证码复制失败"), style: style)
      break
    case 1:
      HUD.show(.toast("评论成功"), for: self.view)
    case 2:
      var style = HUD.Style()
      style.isInteraction = false
      style.maskColor = .red
      let view = UIView()
      view.backgroundColor = .cyan
      view.layer.cornerRadius = 10
      HUD.show(.custom(view, size: CGSize(width: 100, height: 400)), style: style)
    case 3:
      var style = HUD.Style()
      style.isInteraction = false
      style.maskColor = UIColor.red
      style.isTapContentDismiss = true
      HUD.show(.loading(desc: "加载中..........................加载中........................加载中........................End") ,style: style)
    case 4:
      var style = HUD.Style()
      style.maskColor = UIColor.gray.withAlphaComponent(0.5)
      style.contentColor = UIColor.clear
      style.titleColor = .systemGreen
      HUD.show(.loading(.ring), style: style)
    case 5:
      HUD.show(.loading(.lineScaling))
      self.navigationController?.pushViewController(NextViewViewController(), animated: true)
    case 6:
      HUD.show(.succeed())
    case 7:
      HUD.show(.loading())
      DispatchQueue.main.asyncAfter(deadline: .now()+5) {
        HUD.show(.error())
      }
    case 8:
      HUD.show(.progress(handler: {[weak self] (progressView) in
        guard let self = self else {
          return
        }
        self.run(with: progressView)
      }))
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
