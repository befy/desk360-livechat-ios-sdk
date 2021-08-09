//
//  LoginService.swift
//  LiveChat
//
//  Created by Ali Ammar Hilal on 25.04.2021.
//

import Alamofire
import FirebaseAuth
import FirebaseCore
import Foundation

protocol LoginProvider {
    func login(using credential: Credentials) -> Future<AuthResponse, Error>
    func authenticateSession(with token: Token) -> Future<Void, Error>
}

final class LoginProviding: LoginProvider {
	private let client: HttpClient
	
	init(client: HttpClient) {
		self.client = client
	}
	
	func login(using credential: Credentials) -> Future<AuthResponse, Error> {
		let params = ["name": credential.name, "email": credential.email, "source": "iOS"]
		if let chatbot = Storage.settings.object?.chatbot, chatbot == true {
			return client.post(to: .chatbotSession, parameters: params).mapError({
				Logger.logError($0)
				return $0
            })
		} else {
			return client.post(to: .login, parameters: params)
		}
	}
	
	func authenticateSession(with token: Token) -> Future<Void, Error> {
        Logger.Log("TOKEN \(token)")
		let promise = Promise<Void, Error>()
		Auth.liveChat.signIn(withCustomToken: token) { res, error in
			if let error = error {
				Logger.logError(error)
				promise.fail(error: error)
			}
			Logger.log(event: .success, "Firebase Session Key: \(res?.user.uid)"  )
			promise.succeed(value: ())
		}
		return promise.future
	}
}

extension Endpoint {
	static var login: Endpoint {
		return Endpoint(
			path: "/api/v1/chat/sdk/session",
			queryItems: []
		)
	}
	
	static var chatbotSession: Endpoint {
		Endpoint(
			path: "/api/v1/chatbots/create/session",
			queryItems: []
		)
	}
}
