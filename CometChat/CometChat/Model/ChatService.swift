//
//  ChatService.swift
//  CometChat
//
//  Created by Marin Benčević on 25/09/2019.
//  Copyright © 2019 marinbenc. All rights reserved.
//

import Foundation
import CometChatPro

extension String: Error {}

final class ChatService {
  
  private enum Constants {
    static let cometChatAPIKey = "e8fd195a35b515c92853aca3fdfe152c62639cfa"
    static let cometChatAppID = "8839f5c1d57779"
  }
  
  static let shared = ChatService()
  private init() {}
  
  static func initialize() {
    CometChat(
      appId: Constants.cometChatAppID,
      onSuccess: { isSuccess in
        print("CometChat connected successfully: \(isSuccess)")
    },
      onError: { error in
        print(error)
    })
  }
  
  private var user: User?
  
  var onUserStatusChanged: ((User)-> Void)?
  var onReceivedMessage: ((Message)-> Void)?
  
  func login(
    email: String,
    onComplete: @escaping (Result<User, Error>)-> Void) {
    
    CometChat.userdelegate = self
    CometChat.messagedelegate = self

    CometChat.login(
      UID: email,
      apiKey: Constants.cometChatAPIKey,
      onSuccess: { [weak self] cometChatUser in
        guard let self = self else { return }
        self.user = User(cometChatUser)
        DispatchQueue.main.async {
          onComplete(.success(self.user!))
        }
      },
      onError: { error in
        print("Error logging in:")
        print(error.errorDescription)
        DispatchQueue.main.async {
          onComplete(.failure("Error logging in"))
        }
    })
  }
  
  private var usersRequest: UsersRequest?
  func getUsers(onComplete: @escaping ([User])-> Void) {
    usersRequest = UsersRequest.UsersRequestBuilder().build()
    usersRequest?.fetchNext(
      onSuccess: { cometChatUsers in
        let users = cometChatUsers.map(User.init)
        DispatchQueue.main.async {
          onComplete(users)
        }
      },
      onError: { error in
        DispatchQueue.main.async {
          onComplete([])
        }
        print("Fetching users failed with error:")
        print(error?.errorDescription ?? "unknown")
    })
  }
  
  func send(message: String, to receiver: User) {
    guard let user = user else {
      return
    }
    
    let textMessage = TextMessage(
      receiverUid: receiver.id,
      text: message,
      messageType: .text,
      receiverType: .user)
    
    CometChat.sendTextMessage(
      message: textMessage,
      onSuccess: { [weak self] _ in
        guard let self = self else { return }
        print("Message sent")
        DispatchQueue.main.async {
          self.onReceivedMessage?(Message(
            user: user,
            content: message,
            isIncoming: false))
        }
      },
      onError: { error in
        print("Error sending message:")
        print(error?.errorDescription ?? "")
    })
  }
  
  private var messagesRequest: MessagesRequest?
  func getMessages(
    from sender: User,
    onComplete: @escaping ([Message])-> Void) {
    
    guard let user = user else {
      return
    }
    
    let limit = 50
    
    messagesRequest = MessagesRequest.MessageRequestBuilder()
      .set(limit: limit)
      .set(uid: sender.id)
      .build()
    
    messagesRequest!.fetchPrevious(
      onSuccess: { fetchedMessages in
        print("Fetched \(fetchedMessages?.count ?? 0) older messages")
        guard let fetchedMessages = fetchedMessages else {
          onComplete([])
          return
        }
        
        let messages = fetchedMessages
          .compactMap { $0 as? TextMessage }
          .map { Message($0, isIncoming: $0.senderUid.lowercased() != user.id.lowercased()) }
        
        DispatchQueue.main.async {
          onComplete(messages)
        }
      },
      onError: { error in
        print("Fetching messages failed with error:")
        print(error?.errorDescription ?? "unknown")
    })
  }
}

extension ChatService: CometChatUserDelegate {
  
  func onUserOnline(user cometChatUser: CometChatPro.User) {
    DispatchQueue.main.async {
      self.onUserStatusChanged?(User(cometChatUser))
    }
  }
  
  func onUserOffline(user cometChatUser: CometChatPro.User) {
    DispatchQueue.main.async {
      self.onUserStatusChanged?(User(cometChatUser))
    }
  }
}

extension ChatService: CometChatMessageDelegate {
  func onTextMessageReceived(textMessage: TextMessage) {
    DispatchQueue.main.async {
      self.onReceivedMessage?(Message(textMessage, isIncoming: true))
    }
  }
}
