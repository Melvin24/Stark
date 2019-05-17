//
//  AuthHeader.swift
//  App
//
//  Created by Melvin John on 10/05/2019.
//

import Vapor

func authHeader() -> HTTPHeaders {
    let password = "11dbcb82c75291c59cef653a76e38069b7"
    let username = "melvinjohn"

    let userPasswordString = "\(username):\(password)"
    let userPasswordData = userPasswordString.data(using: .utf8)
    let base64EncodedCredential = userPasswordData!.base64EncodedString(options: .init(rawValue: 0))
    let authString = "Basic \(base64EncodedCredential)"

    let header: HTTPHeaders = ["Content-Type": "application/json",
                               "Authorization": "\(authString)"]

    return header
}
