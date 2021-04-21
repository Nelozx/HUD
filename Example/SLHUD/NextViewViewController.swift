//
//  NextViewViewController.swift
//  SLHUD_Example
//
//  Created by Nelo on 2021/4/16.
//  Copyright © 2021 Saloontech. All rights reserved.
//

import UIKit
import SLHUD


class NextViewViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .gray
    
    DispatchQueue.main.asyncAfter(deadline: .now()+3.5) {
      HUD.show(.succeed("成功路过✅"))
    }
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    self.navigationController?.popViewController(animated: true)
    
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
