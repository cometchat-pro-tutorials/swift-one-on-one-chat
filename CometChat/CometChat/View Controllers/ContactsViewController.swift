//
//  ContactsViewController.swift
//  CometChat
//
//  Created by Marin Benčević on 08/09/2019.
//  Copyright © 2019 marinbenc. All rights reserved.
//

import UIKit

final class ContactsViewController: UIViewController {
  
  private enum Constants {
    static let cellIdentifier = "contactsCell"
    static let showChatIdentifier = "showChat"
  }
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewFooter: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableViewFooter.layer.addShadow(
      color: UIColor.black.withAlphaComponent(0.8),
      offset: CGSize(width: 0, height: 2),
      radius: 10)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.shadowImage = nil
  }
}
