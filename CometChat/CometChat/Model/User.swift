//
//  User.swift
//  CometChat
//
//  Created by Marin Benčević on 08/08/2019.
//  Copyright © 2019 marinbenc. All rights reserved.
//

import UIKit
import CometChatPro

struct User: Equatable {
  let id: String
  let name: String
  let image: URL?
  let isOnline: Bool
}

extension User {
  static func ==(lhs: User, rhs: User)-> Bool {
    return lhs.id.lowercased() == rhs.id.lowercased()
  }
}

extension User {
  init(_ cometChatUser: CometChatPro.User) {
    self.id = cometChatUser.uid ?? "unknown"
    self.name = cometChatUser.name ?? "unknown"
    self.image = cometChatUser.avatar.flatMap(URL.init)
    self.isOnline = cometChatUser.status == .online
  }
}
