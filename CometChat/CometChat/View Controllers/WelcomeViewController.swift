//
//  WelcomeViewController.swift
//  CometChat
//
//  Created by Marin Benčević on 08/08/2019.
//  Copyright © 2019 marinbenc. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {
  
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let navigationBar = navigationController?.navigationBar
    navigationBar?.backIndicatorImage = #imageLiteral(resourceName: "back")
    navigationBar?.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
    navigationBar?.barTintColor = .white
    navigationBar?.shadowImage = UIImage()
    
    loginButton.layer.cornerRadius = 5
    
    loginButton.layer.addShadow(
      color: .buttonShadow,
      offset: CGSize(width: 0, height: 5),
      radius: 15)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
}
