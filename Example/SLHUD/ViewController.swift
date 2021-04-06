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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
      HUD.show(.activity(style: .default, title: "呵呵", subtitle: "ss"))
      HUD.show(.succeed())
      HUD.show(.failed())
      
      let custom = UIView()
      HUD.show(.custom(custom))
      HUD.show(.toast("toast !!!!!!!!!"))
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        HUD.dismiss()
      }
    }
}

