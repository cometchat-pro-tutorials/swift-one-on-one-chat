//
//  MessageTableViewCell.swift
//  CometChat
//
//  Created by Marin Benčević on 01/08/2019.
//  Copyright © 2019 marinbenc. All rights reserved.
//

import UIKit

protocol MessageCell: class {
  var message: Message? { get set }
  var showsAvatar: Bool { get set }
}
