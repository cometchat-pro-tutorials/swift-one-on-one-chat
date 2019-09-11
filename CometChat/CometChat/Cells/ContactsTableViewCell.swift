//
//  ContactsTableViewCell.swift
//  CometChat
//
//  Created by Marin Benčević on 08/09/2019.
//  Copyright © 2019 marinbenc. All rights reserved.
//

import UIKit
import Kingfisher

class ContactsTableViewCell: UITableViewCell {

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var statusIndicatorView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    statusIndicatorView.layer.cornerRadius = statusIndicatorView.bounds.width / 2
  }
  
  var contact: User? {
    didSet {
      guard let contact = contact else {
        return
      }

      usernameLabel.text = contact.name
      avatarImageView.kf.setImage(with: contact.image)
      statusIndicatorView.backgroundColor = contact.isOnline ? .online : .placeholderBody
    }
  }
  
}
