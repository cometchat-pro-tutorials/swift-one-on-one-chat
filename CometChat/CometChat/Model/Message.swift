//
//  Message.swift
//  CometChat
//
//  Created by Marin Benčević on 08/08/2019.
//  Copyright © 2019 marinbenc. All rights reserved.
//

import UIKit
import CometChatPro

struct Message {
  let user: User
  let content: String
  let isIncoming: Bool
}

extension Message {
  init(_ textMessage: TextMessage, isIncoming: Bool) {
    user = User(
      id: textMessage.senderUid,
      name: textMessage.sender?.name ?? "unknown",
      image: textMessage.sender?.avatar.flatMap(URL.init),
      isOnline: textMessage.sender?.status == .some(.online))
    content = textMessage.text
    self.isIncoming = isIncoming
  }
}
