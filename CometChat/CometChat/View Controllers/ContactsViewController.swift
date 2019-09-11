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
  
  private var refreshControl = UIRefreshControl()
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewFooter: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.refreshControl = refreshControl
    
    tableView.dataSource = self
    tableView.delegate = self
    tableViewFooter.layer.addShadow(
      color: UIColor.black.withAlphaComponent(0.8),
      offset: CGSize(width: 0, height: 2),
      radius: 10)
    
    ChatService.shared.onUserStatusChanged = { [weak self] user in
      guard let self = self else { return }
      guard let index = self.contacts.firstIndex(of: user) else {
        return
      }
      
      self.contacts[index] = user
      self.tableView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.shadowImage = nil
    refresh()
  }
  
  @objc private func refresh() {
    ChatService.shared.getUsers { [weak self] users in
      self?.refreshControl.endRefreshing()
      self?.contacts = users
      self?.tableView.reloadData()
    }
  }
  
  private var contacts: [User] = []
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case Constants.showChatIdentifier:
      guard
        let chatVC = segue.destination as? ChatViewController,
        let contact = sender as? User
      else {
        return
      }
      
      chatVC.reciever = contact
    default:
      break
    }
  }
}

// MARK: - UITableViewDelegate
extension ContactsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let contact = contacts[indexPath.row]
    performSegue(withIdentifier: Constants.showChatIdentifier, sender: contact)
  }
  
}

// MARK: - UITableViewDataSource
extension ContactsViewController: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard
      let cell = tableView.dequeueReusableCell(
      withIdentifier: Constants.cellIdentifier,
      for: indexPath) as? ContactsTableViewCell
    else {
        return UITableViewCell()
    }
    
    let contact = contacts[indexPath.row]
    cell.contact = contact
    
    return cell
  }
}

