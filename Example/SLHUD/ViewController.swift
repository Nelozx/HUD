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

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//      HUD.show(.activity(style: .default, desc: "呵呵"))
//      HUD.show(.succeed())
//      HUD.show(.error())
//      HUD.show(.progress(0.1, interaction: true))
////      let custom = UIView()
//      HUD.show(.toast("toast !!!!!!!!!"))
//      DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
//        HUD.dismiss()
//      }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell_table")  else {
      return UITableViewCell()
      
    }
    cell.textLabel?.text = "\(indexPath.row)"
    cell.textLabel?.textColor = .systemPink
    
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("---->\(String(describing: view))")
    
    switch indexPath.row {
    case 0:
      HUD.show(.toast("保存成功"))
      break
    case 1:
      HUD.show(.toast("评论成功"), for: self.view)
    case 2:
      HUD.show(.toast("该手机号已注册"), for: self.view)
    case 3:
      HUD.show(.activity())
    case 4:
      HUD.show(.activity(.lineScaling))
    default:
      break
    }
    
  }
  
  
}

