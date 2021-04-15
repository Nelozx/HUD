//
//  ViewController.swift
//  SLHUD
//
//  Created by nelozx@163.com on 04/06/2021.
//  Copyright (c) 2021 nelozx@163.com. All rights reserved.
//

import UIKit
import SLHUD


class ViewController: UIViewController {
  
  struct Model {
    var desc = ""
  }
  
  
  private var models: [Model] = [
    Model(desc: "⏏️: 自定义样式的消息弹窗"),
    Model(desc: "⏏️: 基础消息弹窗"),
    Model(desc: "⏏️: 自定义视图"),
    Model(desc: "⏏️: 系统样式的活动指示器"),
    Model(desc: "⏏️: 转圈活动指示器"),
    Model(desc: "⏏️: 自定义活动指示器"),
    Model(desc: "⏏️: 成功"),
    Model(desc: "⏏️: 失败"),
    Model(desc: "⏏️: 进度"),
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
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    defer {
      switch indexPath.row {
      case 3, 4, 5:
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
      HUD.show(.toast("验证码复制失败"), style: style)
      break
    case 1:
      HUD.show(.toast("评论成功"), for: self.view)
    case 2:
      let view = UIView()
      view.backgroundColor = .cyan
      view.bounds.size = CGSize(width: 100, height: 100)
      HUD.show(.custom(view))
    case 3:
      HUD.show(.loading(desc: "加载中..."))
    case 4:
      var style = HUD.Style()
      style.maskColor = UIColor.gray.withAlphaComponent(0.5)
      style.contentColor = UIColor.clear
      style.titleColor = .systemGreen
      HUD.show(.loading(.ring), style: style)
    case 5:
      HUD.show(.loading(.lineScaling))
    case 6:
      HUD.show(.succeed())
    case 7:
      HUD.show(.error())
    case 8:
      HUD.show(.progress(handler: {[weak self] (progressView) in
        guard let self = self else {
          return
        }
        self.run(with: progressView)
      }))
    break
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
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
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
