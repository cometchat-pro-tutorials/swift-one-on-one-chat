//
//  IncomingMessageTableViewCell.swift
//  CometChat
//
//  Created by Marin Benčević on 08/08/2019.
//  Copyright © 2019 marinbenc. All rights reserved.
//

import UIKit
import Kingfisher

class IncomingMessageTableViewCell: UITableViewCell, MessageCell {
  
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var textBubble: UIView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var textBubblePointer: UIImageView!
  @IBOutlet weak var bottomMargin: NSLayoutConstraint!
  
  private enum Constants {
    static let shadowColor = UIColor(red: 189 / 255, green: 204 / 255, blue: 215 / 255, alpha: 0.54)
    static let shadowRadius: CGFloat = 2
    static let shadowOffset = CGSize(width: 0, height: 1)
    static let chainedMessagesBottomMargin: CGFloat = 20
    static let lastMessageBottomMargin: CGFloat = 32
  }
  
  var message: Message? {
    didSet {
      guard let message = message else {
        return
      }
      
      contentLabel.text = message.content
      userImage.kf.setImage(with: message.user.image)
    }
  }
  
  var showsAvatar = true {
    didSet {
      userImage.isHidden = !showsAvatar
      textBubblePointer.isHidden = !showsAvatar
      bottomMargin.constant = showsAvatar ? Constants.lastMessageBottomMargin : Constants.chainedMessagesBottomMargin
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    textBubble.layer.cornerRadius = 6
    textBubble.layer.addShadow(
      color: Constants.shadowColor,
      offset: Constants.shadowOffset,
      radius: Constants.shadowRadius)
  }
  
}
